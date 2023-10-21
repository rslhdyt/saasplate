class UserMailer < ApplicationMailer
  def invitation(user_id, user_company_id, token)
    @user = User.find(user_id)
    @user_company = UserCompany.find(user_company_id)
    @company = @user_company.company
    @token = token

    mail(
      to: @user.email,
      subject: "Invitation to join #{@company.name}"
    )
  end
end
