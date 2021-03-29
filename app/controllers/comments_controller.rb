class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  expose :question, -> { Question.find_by(id: params[:question_id]) }
  expose :comment, scope: -> { question.comments }, build_params: -> { { author: current_user }.merge(comment_params) }

  def create
    broadcast_comment if comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def broadcast_comment
    ActionCable.server.broadcast(
      "question_#{comment.question_id}_channel",
      { comment: comment }
    )
  end
end
