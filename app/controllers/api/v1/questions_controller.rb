class Api::V1::QuestionsController < Api::V1::BaseController
  expose! :question

  authorize_resource :exposed_question, parent: false, class: 'Question'

  def show
    render json: question, serializer: QuestionFullSerializer
  end

  def index
    render json: Question.all
  end

  def create
    question.author = current_resource_owner

    if question.save
      render json: question, serializer: QuestionFullSerializer
    else
      render json: question.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question, serializer: QuestionFullSerializer
    else
      render json: question.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    question.destroy
  end

  private

  def question_params
    params
      .require(:question)
      .permit(
        :title,
        :body,
        links_attributes: %i[id name url _destroy]
      )
  end
end
