class User < ApplicationRecord
  attr_accessor :remember_token

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

  # ランダムなトークンを生成して返します.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 指定された文字列のハッシュ値を生成して返します.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ハッシュ化したユーザー判定用トークンをデータベースのremember_digestに登録する
  #
  #   User.remember_tokenにランダムなトークンをセット（ハッシュ化していないもの）
  #   Usersテーブルのremember_digestカラムにハッシュ化したトークンをセット
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # データベースのユーザー判定用トークン(remember_digest)を削除する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenicated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
