module InvoiceServices
  class Create < ApplicationService
    class Errors < StandardError; end
    class MissingInvoiceableError < Errors; end

    class PaymentVendorAttributeError < Errors
      def message
        'Mandatory payment vendor attributes are missing'
      end
    end

    def initialize(user, invoiceable)
      @user = user

      # raise MissingInvoiceableError unless invoiceable.is_a? Subscription
      # the invoiceable object is a model that has polymorphic association with invoices
      # so we need to check if the invoiceable object has Invoiceable concern
      raise MissingInvoiceableError unless invoiceable.class.include? Invoiceable

      @invoiceable = invoiceable
    end

    def call
      invoice = create_invoice

      payment_gateway = create_xendit_invoice(invoice)

      update_invoice(invoice, xendit_response)

      invoice
    end

    private

    def create_invoice
      @invoiceable.invoices.create!(
        company: @user.active_company,
        user: @user,
        external_id: SecureRandom.uuid,
        original_amount: @invoiceable.invoice_original_amount,
        fee_amount: @invoiceable.invoice_fee_amount,
        transaction_amount: @invoiceable.invoice_total_amount
      )
    end

    def create_xendit_invoice(invoice)
      xendit_client.invoice.post(params: {
                                   external_id: invoice.external_id,
                                   amount: invoice.transaction_amount,
                                   success_redirect_url: "#{ENV.fetch('APP_URL', nil)}/payments/#{invoice.external_id}/success",
                                   failure_redirect_url: "#{ENV.fetch('APP_URL', nil)}/payments/#{invoice.external_id}/failed"
                                 })
    rescue XenditApi::Errors::ResponseError => e
      invoice.cancelled!

      raise Errors, e.message
    end

    def update_invoice(invoice, xendit_response)
      raise PaymentVendorAttributeError if xendit_response.id.blank?

      invoice.update!(
        payment_vendor_id: xendit_response.id,
        payment_vendor_url: xendit_response.invoice_url,
        status: :unpaid
      )
    end

    def xendit_client
      XenditApi::Client.new(ENV.fetch('XENDIT_SECRET_KEY', nil))
    end
  end
end
