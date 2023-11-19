class SubscriptionPlan < ApplicationRecord
  # associations
  has_many :subscription_packages, dependent: :destroy

  # validations
  validates :name, presence: true, uniqueness: true

  # enums
  enum status: { 
    inactive: 1,
    active: 2 
  }, _default: 'inactive'

end
