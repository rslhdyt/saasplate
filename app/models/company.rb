class Company < ApplicationRecord
  # associations
  has_many :user_companies, dependent: :restrict_with_exception
  has_many :users, through: :user_companies
end
