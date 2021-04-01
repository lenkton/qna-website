class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update]

  expose :question, id: -> { params[:question_id] || Answer.find(params[:id]).question_id }
  expose! :answer,
          build_params: -> { { author: current_user, question: question }.merge(answer_params) },
          scope: -> { Answer.with_attached_files }
  expose :answers, -> { question.answers }
  expose :comment, -> { answer.comments.new }

  authorize_resource :exposed_answer, parent: false, class: 'Answer'

  rescue_from CanCan::AccessDenied, with: :rescue_from_access_denied

  def create
    if answer.save
      flash.now[:notice] = I18n.t('answers.create.success')
      add_files
      AnswerBroadcastingService.publish(answer)
    end
  end

  def destroy
    answer.destroy
    flash.now[:notice] = I18n.t('answers.destroy.success')
  end

  def update
    answer.update(answer_params)
    add_files
  end

  private

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[name url])
  end

  def add_files
    answer.files.attach(params[:answer][:files]) if params[:answer][:files]
  end

  def rescue_from_access_denied
    case action_name
    when 'destroy'
      render action_name, alert: I18n.t('alert.requires_authorization')
    else
      render action_name
    end
  end
end
