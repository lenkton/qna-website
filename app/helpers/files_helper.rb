module FilesHelper
  def file_delete_path(resource)
    case resource.class.name
    when 'Question'
      purge_file_question_path(resource)
    end
  end
end
