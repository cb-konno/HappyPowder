module TasksHelper
  def sort (columnName)
    if request.fullpath.include?('desc')
      link_to (Task.human_attribute_name columnName), sort: columnName, order: 'asc'
    else
      link_to (Task.human_attribute_name columnName), sort: columnName, order: 'desc'
    end
  end
end
