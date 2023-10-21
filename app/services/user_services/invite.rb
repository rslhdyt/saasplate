module UserServices
  class Invite < ApplicationService
    def initialize(inviter, params)
      @inviter = inviter
      @params = params
    end

    def call
      # find or create user by email
      user = User.find_or_initialize_by(email: @params[:email])

      ActiveRecord::Base.transaction do
        create_user(user) if user.new_record?

        token, encrypted_token = generate_token

        user_company = find_or_create_user_company(user, encrypted_token)

        send_notification(user, user_company, token)
      end
    end

    private

    # rubocop:disable Metrics/AbcSize
    def find_or_create_user_company(user, encrypted_token)
      user.user_companies.find_or_create_by!(company_id: @inviter.active_company_id) do |user_company|
        user_company.invitation_token = encrypted_token
        user_company.invitation_created_at = Time.now.utc
        user_company.invitation_sent_at = Time.now.utc
        user_company.invited_by_type = @inviter.class.name
        user_company.invited_by_id = @inviter.id
        user_company.role = @params[:role]
      end
    end
    # rubocop:enable Metrics/AbcSize

    def create_user(user)
      user.name = @params[:name]
      user.invited = true
      user.active_company_id = @inviter.active_company_id
      user.save(validate: false)
    end

    def generate_token
      Devise.token_generator.generate(UserCompany, :invitation_token)
    end

    # rubocop:disable Rails/SkipsModelValidations
    def send_notification(user, user_company, token)
      UserMailer.invitation(user.id, user_company.id, token).deliver_later

      user_company.increment!(:invitations_count)
    end
    # rubocop:enable Rails/SkipsModelValidations
  end
end
