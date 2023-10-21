module UserServices
  class ResendInvitation < ApplicationService
    def initialize(user_company)
      @user_company = user_company
    end

    def call
      token, encrypted_token = generate_token

      @user_company.update!(
        invitation_token: encrypted_token,
        invitation_sent_at: Time.now.utc,
        invitations_count: @user_company.invitations_count + 1
      )

      send_notification(@user_company.user, token)
    end

    private

    def generate_token
      Devise.token_generator.generate(UserCompany, :invitation_token)
    end

    def send_notification(user, token)
      UserMailer.invitation(user.id, @user_company.id, token).deliver_later
    end
  end
end
