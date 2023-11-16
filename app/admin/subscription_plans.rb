ActiveAdmin.register SubscriptionPlan do
  menu parent: 'Subscription Management', priority: 1

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :description, :price, :billing_cycle, :status
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
  filter :billing_cycle, as: :select, collection: SubscriptionPlan.billing_cycles.keys
  filter :status, as: :select, collection: SubscriptionPlan.statuses.keys
end
