class MembershipLevel < ActiveRecord::Base
  validates_numericality_of :monthly_payment
  validates_presence_of :name

  has_many :users
end
