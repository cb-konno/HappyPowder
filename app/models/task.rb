class Task < ApplicationRecord
  # 高:high、中：middle、低：low
  enum priority: {high: 0, middle: 1, low: 2}

  # 未着手：created、着手：doing、完了：done
  enum status: {created: 0, doing: 1, done: 2}

end
