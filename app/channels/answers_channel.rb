class AnswersChannel < ApplicationCable::Channel
  def subscribed
    if question
      stream_from broadcasting_for(question)
    else
      reject
    end
  end

  private

  def question
    @question ||= Question.find_by(id: params['question_id'])
  end
end
