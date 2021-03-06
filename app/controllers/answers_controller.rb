class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update]

  expose :question, id: -> { params[:question_id] || Answer.find(params[:id]).question_id }
  expose :answer, build_params: -> { { author: current_user, question: question }.merge(answer_params) }
  expose :answers, -> { question.answers }

  def create
    flash.now[:notice] = I18n.t('answers.create.success') if answer.save
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash.now[:notice] = I18n.t('answers.destroy.success')
    else
      flash.now[:alert] = I18n.t('alert.requires_authorization')
    end
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
