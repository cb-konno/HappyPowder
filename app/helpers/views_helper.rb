module ViewsHelper
  def sort (columnName)
    if request.fullpath.include?('desc')
      link_to (Task.human_attribute_name columnName), sort: columnName
    else
      link_to (Task.human_attribute_name columnName), sort: columnName + ' desc'
    end
  end
end
