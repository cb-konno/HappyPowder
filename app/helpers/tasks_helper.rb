module TasksHelper
  def sort(columnName)
    order = request.fullpath.include?('desc') ? 'asc' : 'desc'
    link_to Task.human_attribute_name(columnName), sort: columnName, order: order
  end
end
