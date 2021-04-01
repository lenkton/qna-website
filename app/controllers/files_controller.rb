class FilesController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]

  expose! :file, scope: -> { ActiveStorage::Attachment }

  authorize_resource :exposed_file, class: 'ActiveStorage::Attachment', parent: false

  def destroy
    file.purge
  end
end
