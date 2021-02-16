class AnswersController < ApplicationController
  expose :question
  expose :answer
  expose :answers, ->{ question.answers }

  def create
    if question.answers.push(answer)
      redirect_to question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
