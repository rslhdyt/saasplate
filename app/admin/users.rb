ActiveAdmin.register User do
  menu priority: 1, parent: 'User & Company'

  permit_params :name, :email, :password, :password_confirmation, :active_company_id
  
  filter :email
  filter :created_at
  filter :updated_at

  index do 
    selectable_column
    id_column
    column :name
    column :email
    column :active_company
    column :created_at
    actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :email
      f.input :active_company

      f.input :password
      f.input :password_confirmation
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :active_company

      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      
      row :unconfirmed_email
      row :invited

      row :otp_required_for_login
      row :otp_secret
      row :consumed_timestep

      row :created_at
      row :updated_at
    end

    panel 'Companies' do
      table_for user.companies do
        column :name
        column :email

        column :action do |company|
          link_to 'View', admin_company_path(company)
        end
      end
    end
    
    panel 'Auth Providers' do
      table_for user.auth_providers do
        column :name
      end
    end
  end

  action_item :login_as, only: :show do
    link_to 'Login As', login_as_admin_user_path(resource), method: :post
  end

  member_action :login_as, method: :post do
    sign_in(:user, resource)

    redirect_to root_path
  end
end
