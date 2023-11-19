module PaymentLink
  class PaymentGateway
    class Errors < StandardError; end
    
    def initialize(invoice)
      @invoice = invoice
    end

    def create_invoice
      raise NotImplementedError
    end
  end
end
