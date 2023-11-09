module UserServices
  class LoginLink < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      token = @user.signed_id(expires_in: 2.minutes, purpose: :magic_link)

      # send email
      UserMailer.magic_link(@user.id, token)
        .deliver_later

      true
    end
  end
end