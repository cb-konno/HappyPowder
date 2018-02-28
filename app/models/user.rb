class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  has_secure_password validations:

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :mail,
    presence: { message: I18n.t('errors.messages.mail_format') },
    uniqueness: true,
    length: { maximum: 100, message: I18n.t('errors.messages.too_long', count: 100) },
    format: { with: VALID_EMAIL_REGEX, message: I18n.t('errors.messages.mail_format') }
  validates :password,
    length: { maximum: 16, message: I18n.t('errors.messages.too_long', count: 16) }
  validates :name,
    presence: true,
    length: { maximum: 50, message: I18n.t('errors.messages.too_long', count: 50) }
end
