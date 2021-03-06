class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[create new update destroy set_best_answer]

  expose :question
  expose :questions, -> { Question.all }
  expose :answers, -> { question.answers }
  expose :answer,
         scope: -> { question.answers },
         id: -> { params[:answer_id] }

  def create
    if current_user.questions << question
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
    question.update(question_params) if current_user.author_of?(question)
  end

  def set_best_answer
    question.update(best_answer_id: params[:answer_id]) if current_user.author_of?(question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
