class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  expose :commentable, -> { commentable_klass.find_by(id: params[commentable_id_sym]) }
  expose :comment, scope: -> { commentable.comments }, build_params: -> { { author: current_user }.merge(comment_params) }

  def create
    respond_to do |format|
      if comment.save
        broadcast_comment
        format.json { render json: comment_info }
      else
        format.json { render json: { comment: comment, errors: comment.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def broadcast_comment
    ActionCable.server.broadcast(
      "question_#{channel_id}_channel",
      comment_info
    )
  end

  def comment_info
    { comment: comment }
  end

  def commentable_type
    params[:commentable].to_sym
  end

  def commentable_klass
    commentable_type.to_s.classify.constantize
  end

  def commentable_id_sym
    "#{commentable_type}_id".to_sym
  end

  def channel_id
    case commentable_type
    when :answer then commentable.question_id
    when :question then commentable.id
    end
  end
end
