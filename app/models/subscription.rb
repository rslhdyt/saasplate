class Subscription < ApplicationRecord
  # associations
  belongs_to :subscription_plan
  belongs_to :company
  has_many :invoices, as: :invoiceable, dependent: :destroy

  # validations
  validates :subscription_plan_id, presence: true
  validates :company_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  
  # enums
  enum status: {
    pending: 1,
    active: 2,
    canceled: 3,
    paused: 4,
    expired: 5,
    trialling: 6
  }, _default: 'pending'

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
