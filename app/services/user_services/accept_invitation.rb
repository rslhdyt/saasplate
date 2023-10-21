module UserServices
  class AcceptInvitation < ApplicationService
    class Errors < StandardError; end

    class TokenInvalid < Errors
      def message
        'Invalid invitation token'
      end
    end

    def initialize(token)
      @token = token
    end

    def call
      token = nil
      user_company = find_user_company
      user = user_company.user

      ActiveRecord::Base.transaction do
        update_user_company(user_company)

        if user.encrypted_password.blank?
          token, encrypted_token = generate_reset_password_token

          setup_reset_password(user, encrypted_token)
        end
      end

      resolve_response(user, token)
    end

    private

    def resolve_response(user, token)
      {
        user: user,
        password_token: token
      }.with_indifferent_access
    end

    def update_user_company(user_company)
      user_company.update!(
        invitation_token: nil,
        invitation_accepted_at: Time.now.utc
      )
    end

    def generate_reset_password_token
      Devise.token_generator.generate(User, :reset_password_token)
    end

    def setup_reset_password(user, encrypted_token)
      user.update!(
        reset_password_token: encrypted_token,
        reset_password_sent_at: Time.now.utc
      )
    end

    def decrypted_token
      Devise.token_generator.digest(UserCompany, :invitation_token, @token)
    end

    def find_user_company
      UserCompany.find_by!(invitation_token: decrypted_token, invitation_accepted_at: nil)
    rescue ActiveRecord::RecordNotFound
      raise TokenInvalid
    end
  end
end
