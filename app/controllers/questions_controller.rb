class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[create new]
  expose :question
  expose :questions, -> { Question.all }
  expose :answers, -> { question.answers }
  expose :answer, -> { question.answers.new }

  def create
    if current_user.questions << question
      redirect_to question, notice: I18n.t('questions.create.success')
    else
      render :new
    end
  end

  def destroy
    if current_user&.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: I18n.t('questions.destroy.success')
    else
      redirect_to question, alert: I18n.t('alert.requires_authorization')
    end
  end

  def update
    question.update(question_params) if current_user&.author_of?(question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
