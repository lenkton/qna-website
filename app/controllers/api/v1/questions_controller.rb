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
    if current_user.questions << question
      render json: question, serializer: QuestionFullSerializer
    else
      head :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question, serializer: QuestionFullSerializer
    else
      head :unprocessable_entity
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