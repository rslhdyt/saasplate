class Company < ApplicationRecord
  # associations
  belongs_to :owner, class_name: 'User', optional: true
  has_many :user_companies, dependent: :restrict_with_exception
  has_many :users, through: :user_companies
  has_many :subscriptions

  # validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  # delegates
  delegate :subscription_plan, to: :subscription_package

  # scopes

  def active_subscription
    subscriptions.active.order(id: :desc).last
  end
end
