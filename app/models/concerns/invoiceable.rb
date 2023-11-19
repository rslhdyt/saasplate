module Invoiceable
  extend ActiveSupport::Concern

  included do
    has_many :invoices, as: :invoiceable, dependent: :destroy
  end

  def invoice_total_amount
    raise NotImplementedError
  end
end