class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  has_secure_password

  # validates :password, presence: true, length: { minimum: 6 }

  validates :password, length: {minimum: 8}, allow_nil: true

  has_many :news_articles
  has_many :asset_tools, :class_name => 'Asset::Tool'
  has_many :index_images

  cattr_accessor :current_user

  private

  def self.cu_is_admin?
    return User.user_is_admin?(User.current_user)
  end

  def self.user_is_admin?(user)
    if user
      return user[:admin]
    else
      return false
    end
  end

end
