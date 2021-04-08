class Api::V1::AnswersController < Api::V1::BaseController
  expose :question, id: -> { params[:question_id] || Answer.find(params[:id]).question_id }
  expose! :answer

  authorize_resource :exposed_answer, parent: false, class: 'Answer'

  def show
    render json: answer, serializer: AnswerFullSerializer
  end

  def index
    render json: question.answers
  end

  def create
    answer.author = current_resource_owner
    answer.question = question

    if answer.save
      render json: answer, serializer: AnswerFullSerializer
    else
      render json: answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if answer.update(answer_params)
      render json: answer, serializer: AnswerFullSerializer
    else
      render json: answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
  end
end
