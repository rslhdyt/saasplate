ActiveAdmin.register UserCompany do
  menu false

  belongs_to :company

  form title: proc { "Invite User to Company #{parent.name}" } do |f|
    f.inputs do
      f.input :invited_by, 
        collection: parent.company.users.map { |user| [user.name, user.id] },
        label: "Inviter"  
      f.input :user_name, :as => :string, :label => "User Name"  
      f.input :user_email, :as => :string, :label => "User Email"  
    end

    f.actions
  end

  controller do
    def create
      inviter = User.find(params[:user_company][:invited_by_id])
      @user = Users::InvitationForm.new(inviter, {
        name: params[:user_company][:user_name],
        email: params[:user_company][:user_email]
      })
      
      if @user.save
        redirect_to admin_company_path(parent), notice: 'User has been invited to company'
      else
        render :new
      end
    end
  end

  action_item :resend_invitation, only: :show do
    link_to 'Resend Invitation', 
      resend_invitation_admin_company_user_company_path(resource.company, resource),
      method: :post if resource.invitation_token.present?
  end

  member_action :resend_invitation, method: :post do
    UserServices::ResendInvitation.call(resource)

    redirect_to admin_company_path(resource.company), notice: 'Invitation has been resent'
  end
end
