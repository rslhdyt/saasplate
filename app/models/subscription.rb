class Subscription < ApplicationRecord
  include Subscriptionable
  include Invoiceable

  # associations
  belongs_to :subscription_package
  belongs_to :company
  has_many :invoices, as: :invoiceable, dependent: :destroy

  # validations
  validates :subscription_package_id, presence: true
  validates :company_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :billing_duration, presence: true
  validate :end_date_after_start_date

  # delegates
  delegate :subscription_plan_name, to: :subscription_package
  
  # enums
  enum status: {
    init: 0,
    pending: 1,
    active: 2,
    canceled: 3,
    paused: 4,
    expired: 5,
    trialling: 6
  }, _default: 'init'

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  def total_amount
    price
  end
end
