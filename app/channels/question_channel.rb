class QuestionChannel < ApplicationCable::Channel
  def subscribed
    reject unless params[:question_id]

    stream_from "question_#{params[:question_id]}_channel"
  end
end
