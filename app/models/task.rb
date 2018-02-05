# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  name         :varchar(255)
#  description  :text
#  priority     :enum
#  status       :enum
#  start_at     :datetime
#  ended_at     :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Task < ApplicationRecord
  enum priority: { high: 0, middle: 1, low: 2 }

  enum status: { created: 0, doing: 1, done: 2 }
end
