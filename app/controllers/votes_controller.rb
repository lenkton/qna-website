class VotesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  expose :question, id: -> { params[:question_id] || Vote.find(params[:id]).question_id }
  expose :vote, scope: -> { question.votes },
                build_params: -> { { user: current_user }.merge(vote_params) }

  def create
    respond_to do |format|
      vote.save
      format.json { render json: vote }
    rescue
      format.json { render json: vote.errors.full_messages, status: :unprocessable_entity }
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:supportive)
  end
end
