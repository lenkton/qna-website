class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[create new update destroy set_best_answer]

  expose :question, scope: -> { Question.with_attached_files }
  expose :questions, -> { Question.all }
  expose :answers, -> { question.answers.filter(&:persisted?) }
  expose :answer,
         scope: -> { question.answers },
         id: -> { params[:answer_id] }

  def new
    question.links.new
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
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: I18n.t('questions.destroy.success')
    else
      redirect_to question, alert: I18n.t('alert.requires_authorization')
    end
  end

  def update
    if current_user.author_of?(question)
      question.update(question_params)
      add_files
    end
  end

  def set_best_answer
    question.update(best_answer_id: params[:answer_id]) if current_user.author_of?(question)
  end

  private

  def add_files
    question.files.attach(params[:question][:files]) if params[:question][:files]
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url])
  end
end
