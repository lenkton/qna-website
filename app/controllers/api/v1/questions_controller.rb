class Api::V1::QuestionsController < Api::V1::BaseController
  expose! :question

  authorize_resource :exposed_question, parent: false, class: 'Question'

  def show
    render json: question, serializer: QuestionFullSerializer
  end

  def index
    render json: Question.all
  end
end
