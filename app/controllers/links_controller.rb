class LinksController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]

  expose! :link

  authorize_resource :exposed_link, parent: false, class: 'Link'

  def destroy
    link.destroy
  end
end
