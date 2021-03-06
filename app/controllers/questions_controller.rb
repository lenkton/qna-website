class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[create new update destroy set_best_answer]

  after_action :publish_question, only: [:create]

  expose! :question, scope: -> { Question.with_attached_files }
  expose :questions, -> { Question.all }
  expose :answers, -> { question.answers.filter(&:persisted?) }
  expose :answer,
         scope: -> { question.answers },
         id: -> { params[:answer_id] }
  expose :comment, -> { question.comments.new }
  expose :subscribing, -> { Subscribing.find_by(subscriber_id: current_user&.id, subscription_id: question.id) || Subscribing.new }

  authorize_resource :exposed_question, parent: false, class: 'Question'

  rescue_from CanCan::AccessDenied, with: :rescue_from_access_denied

  def new
    question.links.new
    question.reward = Reward.new
  end

  def show
    answer.links.new
  end

  def create
    if current_user.questions << question
      add_files
      redirect_to question, notice: I18n.t('questions.create.success')
    else
      render :new
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: I18n.t('questions.destroy.success')
  end

  def update
    question.update(question_params)
    add_files
  end

  def set_best_answer
    answer.choose_best!
    flash[:notice] = (flash[:notice] || '') + I18n.t('questions.set_best_answer.user_rewarded', name: answer.author.email)
  rescue
  end

  private

  def add_files
    question.files.attach(params[:question][:files]) if params[:question][:files]
  end

  def question_params
    params
      .require(:question)
      .permit(
        :title,
        :body,
        links_attributes: %i[id name url _destroy],
        reward_attributes: %i[id name image _destroy]
      )
  end

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
      'questions_channel',
      question
    )
  end

  def rescue_from_access_denied
    case action_name
    when 'destroy'
      redirect_to question, alert: I18n.t('alert.requires_authorization')
    else
      render action_name
    end
  end
end
