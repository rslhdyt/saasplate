class Invoice < ApplicationRecord
  # associations
  belongs_to :invoiceable, polymorphic: true
end
