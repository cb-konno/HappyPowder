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

  validates :name, presence: true, length: { maximum: 50, messages: I18n.t('errors.messages.too_long', count: 50) }

  validates :status, presence: { message: I18n.t('errors.messages.select') }

  validates :priority, presence: { message: I18n.t('errors.messages.select') }
end
