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
    answer.author_id = doorkeeper_token.resource_owner_id

    if question.answers << answer
      render json: answer, serializer: AnswerFullSerializer
    else
      head :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
  end
end
