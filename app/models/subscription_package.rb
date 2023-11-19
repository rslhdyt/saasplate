class SubscriptionPackage < ApplicationRecord
  include Subscriptionable

  # associations
  belongs_to :subscription_plan
  has_many :subscriptions, dependent: :destroy

  # enums
  enum status: {
    inactive: 1,
    active: 2
  }, _default: 'inactive'

  # delegations
  delegate :name, to: :subscription_plan, prefix: true

  def end_date_from_now
    return billing_duration.months.from_now if monthly?
    return billing_duration.years.from_now if annually?
    return billing_duration.weeks.from_now if weekly?

    nil
  end
end
