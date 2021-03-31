class AnswerBroadcastingService
  class << self
    def publish(answer)
      AnswersChannel.broadcast_to(
        answer.question,
        {
          answer: answer,
          links: answer.links.map { |link| compose_link(link) },
          files: compose_files(answer),
          rating: answer.rating
        }
      )
    end

    def compose_files(answer)
      answer.files.map { |file| compose_file(file) }
    end

    def compose_file(file)
      {
        name: file.filename.to_s,
        url: Rails.application.routes.url_helpers.polymorphic_url(file, only_path: true),
        id: file.id
      }
    end

    def compose_link(link)
      resp = link.attributes
      resp[:gist] = ApplicationController.helpers.gist_files(link.url) if ApplicationController.helpers.gist?(link.url)
      resp
    end
  end
end
