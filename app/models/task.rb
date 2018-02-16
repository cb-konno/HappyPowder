# == Schema Information
#
# Table name: messages
#
#  id           :integer                  not null, primary key
#  name         :string (50)              not null
#  description  :string (2000)
#  priority     :enum
#  status       :enum
#  start_on     :date
#  ended_on     :datet
#  created_at   :datetime                  not null
#  updated_at   :datetime                  not null
#
#
# Indexes:
#   tasks_pkey PRIMARY KEY, btree (id)
#   index_tasks_on_name   btree (name)
#   index_tasks_on_status btree (status)
#
class Task < ApplicationRecord
  enum priority: { high: 0, middle: 1, low: 2 }
  enum status: { created: 0, doing: 1, done: 2 }

  validates :name, presence: true, length: { maximum: 50, messages: I18n.t('errors.messages.too_long', count: 50) }
  validates :description, length: { maximum: 2000, messages: I18n.t('errors.messages.too_long', count: 2000) }
  validates :status, presence: { message: I18n.t('errors.messages.select') }
  validates :priority, presence: { message: I18n.t('errors.messages.select') }
end
