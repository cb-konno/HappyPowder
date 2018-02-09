module TasksHelper
  def status_selection
    options = [
      [],
      [t('task.status.created'), 'created'],
      [t('task.status.doing'), 'doing'],
      [t('task.status.done'), 'done']]
  end

  def priority_selection
    options = [
      [],
      [t('task.priority.high'), 'high'],
      [t('task.priority.middle'), 'middle'],
      [t('task.priority.low'), 'low']]
  end
end
