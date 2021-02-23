class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  expose :question, id: -> { params[:question_id] || Answer.find(params[:id]).question_id }
  expose :answer, build_params: -> { { user: current_user, question: question }.merge(answer_params) }
  expose :answers, -> { question.answers }

  def create
    if answer.save
      redirect_to question, notice: I18n.t('answers.create.success')
    else
      render 'questions/show'
    end
  end

  def destroy
    if answer.user == current_user
      answer.destroy
      redirect_to answer.question, notice: I18n.t('answers.destroy.success')
    else
      flash.now[:alert] = I18n.t('alert.requires_authorization')
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
