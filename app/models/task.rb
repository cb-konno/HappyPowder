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
  # カラム一覧
  ALLOWED_COLUMN = self.column_names.freeze

  # hoge
  ALLOWED_ORDER = %w(asc desc).freeze

  enum priority: { high: 0, middle: 1, low: 2 }
  enum status: { created: 0, doing: 1, done: 2 }

  validates :name, presence: true, length: { maximum: 50, messages: I18n.t('errors.messages.too_long', count: 50) }
  validates :description, length: { maximum: 2000, messages: I18n.t('errors.messages.too_long', count: 2000) }
  validates :status, presence: { message: I18n.t('errors.messages.select') }
  validates :priority, presence: { message: I18n.t('errors.messages.select') }

  scope :sort_list, -> (sort = 'created_at', order = 'desc') {
    if sort.in?(ALLOWED_COLUMN) && order.in?(ALLOWED_ORDER)
      order("#{sort}": order)
    else
      order(created_at: :desc)
    end
  }
end
