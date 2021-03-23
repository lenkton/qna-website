class VotesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  expose :question, id: -> { params[:question_id] || Vote.find(params[:id]).question_id }
  expose :vote, scope: -> { question.votes },
                build_params: -> { { author: current_user }.merge(vote_params) }

  def create
    respond_to do |format|
      vote.save
      format.json { render json: { question: { vote: { status: :created, supportive: vote.supportive, id: vote.id } } } }
    rescue
      format.json { render json: vote.errors.full_messages, status: :unprocessable_entity }
    end
  end

  def destroy
    respond_to do |format|
      if current_user.author_of?(vote)
        vote.destroy
        format.json { render json: { question: { vote: { status: :deleted, previous_value: vote.supportive } } } }
      else
        format.json { head :unauthorized }
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:supportive)
  end
end
