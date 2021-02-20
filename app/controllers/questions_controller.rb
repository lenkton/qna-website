class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[create new]
  expose :question
  expose :questions, -> { Question.all }
  expose :answers, -> { question.answers }
  expose :answer, -> { question.answers.new }

  def create
    if question.save
      redirect_to question, notice: I18n.t('questions.create.success')
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
