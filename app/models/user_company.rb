class UserCompany < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :company
  belongs_to :invited_by, polymorphic: true, optional: true

  # filter user companies by invitation
  scope :invited, -> { where.not(invitation_created_at: nil) }
  scope :invitation_accepted, -> { invited.where.not(invitation_accepted_at: nil) }
  scope :invitation_not_accepted, -> { invited.where(invitation_accepted_at: nil) }
end
