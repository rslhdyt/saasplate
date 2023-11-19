module PaymentLink
  class Xendit < PaymentGateway
    def create_invoice
      response = create_xendit_invoice

      update_invoice(response)
    rescue XenditApi::Errors::ResponseError => e
      invoice.cancelled!

      raise Errors, e.message
    end

    private

    def create_xendit_invoice
      xendit_client.invoice.post(params: {
        external_id: @invoice.external_id,
        amount: @invoice.total_amount,
        success_redirect_url: "#{ENV.fetch('APP_URL', nil)}/xendit/payments/#{@invoice.external_id}/success",
        failure_redirect_url: "#{ENV.fetch('APP_URL', nil)}/xendit/payments/#{@invoice.external_id}/failed"
      })
    end

    def xendit_client
      @xendit_client ||= XenditApi::Client.new
    end
  end
end