class VotesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  expose :votable, -> { Vote.find_by(id: params[:id])&.votable || find_votable }
  expose! :vote, scope: -> { votable.votes },
                 build_params: -> { { author: current_user }.merge(vote_params) }

  authorize_resource :exposed_vote, parent: false, class: 'Vote'

  rescue_from NameError, with: :name_error_handler

  def create
    respond_to do |format|
      if current_user.author_of?(votable)
        format.json { head :forbidden }
      elsif vote.save
        format.json { render json: { votable_sym => { vote: { status: :created, value: vote.value, id: vote.id } } } }
      else
        format.json { head :unprocessable_entity }
      end
    rescue
      format.json { head :unprocessable_entity }
    end
  end

  def destroy
    respond_to do |format|
      vote.destroy
      format.json { render json: { votable_sym => { vote: { status: :deleted, previous_value: vote.value } } } }
    end
  end

  private

  def votable_sym
    votable.class.name.underscore.to_sym
  end

  def vote_params
    params.require(:vote).permit(:value)
  end

  def find_votable
    votable_name.to_s.classify.constantize.find(params[votable_id_sym])
  end

  def votable_name
    params[:votable]
  end

  def votable_id_sym
    "#{votable_name.to_s.singularize}_id".to_sym
  end

  def name_error_handler
    respond_to do |format|
      format.json { head :unprocessable_entity }
    end
  end
end
