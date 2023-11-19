ActiveAdmin.register Subscription do
  menu parent: 'Subscription Management', priority: 1
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :subscription_plan_id, :company_id, :start_date, :end_date, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:subscription_plan_id, :company_id, :price, :billing_cycle, :start_date, :end_date, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  filter :subscription_plan
  filter :company
  filter :start_date
  filter :end_date
  filter :status, as: :select, collection: Subscription.statuses.keys
end
