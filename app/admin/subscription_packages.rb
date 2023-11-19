ActiveAdmin.register SubscriptionPackage do
  menu parent: 'Subscription Management', priority: 2

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :subscription_plan_id, :price, :billing_cycle, :billing_duration, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :billing_cycle, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  filter :name
  filter :price
  filter :billing_cycle
  filter :billing_duration
  filter :status, as: :select, collection: SubscriptionPackage.statuses.keys
end
