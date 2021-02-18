class AnswersController < ApplicationController
  expose :question
  expose :answer
  expose :answers, -> { question.answers }

  def create
    if question.answers << answer
      redirect_to question, notice: I18n.t('answers.create.success')
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
