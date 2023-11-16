ActiveAdmin.register Invoice do
  menu parent: 'Subscription Management', priority: 3
  
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :invoiceable_type, :invoiceable_id, :user_id, :total_amount, :issue_date, :due_date, :status, :pg_gateway, :pg_gateway_ref, :invoice_url, :invoice_number, :paid_amount, :paid_date, :payment_method
  #
  # or
  #
  # permit_params do
  #   permitted = [:invoiceable_type, :invoiceable_id, :user_id, :total_amount, :issue_date, :due_date, :status, :pg_gateway, :pg_gateway_ref, :invoice_url, :invoice_number, :paid_amount, :paid_date, :payment_method]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
