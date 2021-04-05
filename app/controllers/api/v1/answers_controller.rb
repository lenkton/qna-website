class Api::V1::AnswersController < Api::V1::BaseController
  expose! :answer

  authorize_resource :exposed_answer, parent: false, class: 'Answer'

  def show
    render json: answer, serializer: AnswerFullSerializer
  end

  def index
    render json: Answer.all
  end
end
