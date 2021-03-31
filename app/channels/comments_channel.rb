class CommentsChannel < ApplicationCable::Channel
  def subscribed
    if params['commentable_type'] && commentable
      stream_from broadcasting_for(commentable)
    else
      reject
    end
  end

  private

  def commentable
    @commentable ||= commentable_klass.find_by(id: params['commentable_id'])
  end

  def commentable_klass
    @commentable_klass ||= params['commentable_type'].classify.constantize
  end
end
