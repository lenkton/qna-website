module ApplicationHelper
  def resources_sym(resource)
    resource.class.name.underscore.pluralize.to_sym
  end
end
