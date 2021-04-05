class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :created_at

  def url
    Rails.application.routes.url_helpers.polymorphic_url(object, only_path: true)
  end
end
