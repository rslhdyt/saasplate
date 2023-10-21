class UserCompany < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :company
end
