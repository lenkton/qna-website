class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update]

  expose :question, id: -> { params[:question_id] || Answer.find(params[:id]).question_id }
  expose :answer,
         build_params: -> { { author: current_user, question: question }.merge(answer_params) },
         scope: -> { Answer.with_attached_files }
  expose :answers, -> { question.answers }
  expose :file, -> { answer.files.find_by(id: params[:file_id]) }

  def create
    if answer.save
      flash.now[:notice] = I18n.t('answers.create.success')
      add_files
    end
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
    if current_user.author_of?(answer)
      answer.update(answer_params)
      add_files
    end
  end

  def purge_file
    file.purge if file.present? && current_user.author_of?(answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def add_files
    answer.files.attach(params[:answer][:files]) if params[:answer][:files]
  end
end
