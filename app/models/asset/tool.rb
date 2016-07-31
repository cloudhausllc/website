class Asset::Tool < ActiveRecord::Base
  validates :name, :quantity, :sqft, :value,  presence: true
  validates :active, :on_premises, inclusion: [true, false]
  validates :quantity, :sqft, :numericality => { :greater_than_or_equal_to => 0 }

  before_validation :set_owner

  belongs_to :user

  default_scope {
    order(created_at: :desc)

    if not User.cu_is_admin?
      visible_tools
    end
  }

  scope :visible_tools, -> {
    where(active: true, on_premises: true)
  }

  private

  def set_owner
    if User.current_user
      self.user_id = User.current_user[:id]
    end
  end
end
