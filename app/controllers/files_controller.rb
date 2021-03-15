class FilesController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]

  expose :file, scope: -> { ActiveStorage::Attachment }

  def destroy
    file.purge if current_user.author_of?(file.record)
  end
end
