class SubscriptionPlan < ApplicationRecord
  # associations
  has_many :subscriptions, dependent: :destroy

  # validations
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true

  # enums
  enum status: { 
    inactive: 1,
    active: 2 
  }, _default: 'inactive'

  enum billing_cycle: {
    monthly: 1,
    annually: 2
  }, _default: 'monthly'
end
