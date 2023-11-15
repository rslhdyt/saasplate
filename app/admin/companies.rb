ActiveAdmin.register Company do
  menu priority: 2, parent: 'User & Company'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :owner_id, :name, :email, :phone, :address
  #
  # or
  #
  # permit_params do
  #   permitted = [:owner_id, :name, :email, :phone, :address]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  filter :id
  filter :owner
  filter :name
  filter :email
  filter :created_at

  show do
    attributes_table do
      row :id
      row :owner
      row :name
      row :email
      row :phone
      row :address
      row :created_at
      row :updated_at
    end

    panel "Users" do
      table_for company.user_companies do
        column :id
        column :user_email
        column :created_at
        column :updated_at
        
        column :actions do |user_company|
          link_to 'View', admin_company_user_company_path(user_company.company_id, user_company.id)
        end
      end
    end
  end

  action_item :invite_user, only: :show do
    link_to 'Invite User To Company', new_admin_company_user_company_path(resource)
  end

  # create custom action to calculate deal manually
  member_action :recalculate, method: :post do
    redirect_to admin_deal_path(resource.id), notice: 'Cannot calculate deal that is not won' unless resource.won?

    DealServices::CalculateDeal.call(resource)

    # TODO: support internationalization
    redirect_to admin_deal_path(resource.id), notice: 'Deal was successfully recalculated!'
  end
end
