# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# create if not exist

AdminUser.find_or_create_by(email: ENV['ADMIN_USER_EMAIL']) do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end

if Rails.env.development?
  subscription_plans = %w[Free Basic Premium Enterprise]
  base_price = 1000

  subscription_plans.each_with_index do |plan, index|
    SubscriptionPlan.find_or_create_by(name: plan) do |subscription_plan|
      subscription_plan.description = "This is #{plan} plan"
      subscription_plan.price = base_price * (index + 1)
      subscription_plan.billing_cycle = :monthly
      subscription_plan.status = :active
    end
  end
end