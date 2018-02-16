# == Schema Information
#
# Table name: messages
#
#  id           :integer    not null, primary key
#  name         :string     not null
#  description  :string
#  priority     :enum
#  status       :enum
#  start_on     :date
#  ended_on     :datet
#  created_at   :datetime   not null
#  updated_at   :datetime   not null
#
#
# Indexes:
#   tasks_pkey PRIMARY KEY, btree (id)
#   index_tasks_on_name   btree (name)
#   index_tasks_on_status btree (status)
#
class Task < ApplicationRecord
  ALLOWED_COLUMN = self.column_names.freeze

  ALLOWED_ORDER = %w(asc desc).freeze

  enum priority: { high: 0, middle: 1, low: 2 }
  enum status: { created: 0, doing: 1, done: 2 }

  validates :name, presence: true, length: { maximum: 50, messages: I18n.t('errors.messages.too_long', count: 50) }
  validates :description, length: { maximum: 2000, messages: I18n.t('errors.messages.too_long', count: 2000) }
  validates :status, presence: { message: I18n.t('errors.messages.select') }
  validates :priority, presence: { message: I18n.t('errors.messages.select') }

  # パラメータのソート順をチェックしてransackで検索
  def self.ransack_with_check_params(params = {})
    if params[:q].present? && params[:q][:s].present?

      column, order = params[:q][:s].split(' ')

      # ASC/DESC以外が指定された場合は、「DESC」をデフォルトにする
      order = 'DESC' if ALLOWED_ORDER.exclude?(order)

      # 不正なカラム名が指定された場合は、「created_at」をデフォルトにする
      params[:q][:s] = ALLOWED_COLUMN.include?(column) ? "#{column} #{order}" : "created_at #{order}"

    elsif params[:q].present?
      # 検索フォームから
      params[:q][:s] = 'created_at DESC'
    else
      # 画面初期表示
      params[:q] = { s: 'created_at DESC' }
    end
    ransack(params[:q])
  end
end
