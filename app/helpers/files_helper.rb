module FilesHelper
  def file_delete_path(resource)
    case resource.class.name
    when 'Question'
      purge_file_question_path(resource)
    when 'Answer'
      purge_file_answer_path(resource)
    end
  end
end
