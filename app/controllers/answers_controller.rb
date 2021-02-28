class AnswersController < ApplicationController
  expose :question, id: -> { params[:question_id] || Answer.find(params[:id]).question_id }
  expose :answer, build_params: -> { { author: current_user, question: question }.merge(answer_params) }
  expose :answers, -> { question.answers }

  def create
    if user_signed_in?
      flash.now[:notice] = I18n.t('answers.create.success') if answer.save
    else
      flash.now[:alert] = I18n.t('devise.failure.unauthenticated')
    end
  end

  def destroy
    if current_user&.author_of?(answer)
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
