class NewsArticle < ActiveRecord::Base
  belongs_to :user

  validates :subject, :body, :user, presence: true
  validates :published, inclusion: [true, false]
  before_validation :set_author

  default_scope {
    order(created_at: :desc)

    if not User.cu_is_admin?
      published_articles
    end
  }

  scope :published_articles, -> {
    where(published: true)
  }

  private

  def set_author
    if User.current_user
      self.user_id = User.current_user[:id]
    end
  end
end
