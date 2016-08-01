class IndexImage < ActiveRecord::Base
  has_attached_file :image, styles: { full: "800x400>", thumb: "200x100>" }, default_url: "/images/missing_image.png"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  before_validation :set_owner

  belongs_to :user

  default_scope {
    order(created_at: :asc)
    if not User.cu_is_admin?
      active_images
    end
  }

  scope :active_images, -> {
    where(active: true)
  }

  private

  def set_owner
    if User.current_user
      self.user_id = User.current_user[:id]
    end
  end
end
