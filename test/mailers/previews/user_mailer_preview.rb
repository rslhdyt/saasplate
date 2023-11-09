# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def invitation
    user = User.first
    user_company = user.user_companies.first
    token = Devise.token_generator.generate(UserCompany, :invitation_token)

    UserMailer.invitation(user.id, user_company.id, token)
  end

  def magic_link
    user = User.first
    token = user.signed_id(expires_in: 15.minutes, purpose: :magic_link)

    UserMailer.magic_link(user.id, token)
  end
end
