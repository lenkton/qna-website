class LinksController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]

  expose :link

  def destroy
    link.destroy if current_user.author_of?(link.linkable)
  end
end
