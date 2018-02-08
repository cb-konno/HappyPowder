# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  name         :varchar(255)
#  description  :text
#  priority     :enum
#  status       :enum
#  start_on     :date
#  ended_on     :datet
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Task < ApplicationRecord
  enum priority: { high: 0, middle: 1, low: 2 }

  enum status: { created: 0, doing: 1, done: 2 }

  validates :name, presence: true

end
