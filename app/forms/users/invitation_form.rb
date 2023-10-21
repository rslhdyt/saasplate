module Users
  class InvitationForm
    include ActiveModel::Model

    attr_accessor :name,
                  :email

    validates_presence_of :name, :email
    validates_format_of :email, with: Devise.email_regexp

    def initialize(current_user, params = {})
      @current_user = current_user

      super(params)
    end

    def save
      return false if invalid?

      invite
    end

    def self.model_name
      ActiveModel::Name.new(self, nil, 'User')
    end

    private

    def invite
      UserServices::Invite.call(@current_user, user_params)
    end

    def user_params
      {
        name: name,
        email: email
      }
    end
  end
end
