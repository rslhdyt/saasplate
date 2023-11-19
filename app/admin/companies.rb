ActiveAdmin.register Company do
  menu priority: 2, parent: 'User & Company'

  includes user_companies: :user

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

    panel "Subscriptions" do
      table_for company.subscriptions do
        column :id
        column :subscription_package do |subscription|
          subscription.subscription_package.subscription_plan_name
        end
        column :start_date
        column :end_date
        column :status
        column :created_at

        column :actions do |subscription|
          link_to 'View', admin_subscription_path(subscription.id)
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

  # add sidebar to show page
  sidebar 'Active Subscription', only: :show do
    attributes_table_for company.active_subscription do
      row :id
      row :subscription_plan_name
      row :start_date
      row :end_date
      row :price
      row :status
      row :created_at
      row :updated_at
    end

    # add link to create new subscription
    link_to 'Create New Subscription', new_admin_subscription_path(company_id_eq: company.id)
  end

end
