class Company < ApplicationRecord
  # associations
  has_many :user_companies, dependent: :restrict_with_exception
  has_many :users, through: :user_companies

  # validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
