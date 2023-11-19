if (SubscriptionPlan.count == 0 && SubscriptionPackage.count == 0)
  subscription_plans = %w[Free Basic Premium Enterprise]
  billing_cycles = %w[monthly annually]
  base_price = 1000
  features = ['feature1', 'feature2', 'feature3', 'feature4', 'feature5']

  subscription_plans.each_with_index do |plan, index|
    subscription_plan = SubscriptionPlan.find_or_create_by(name: plan) do |subscription_plan|
      subscription_plan.description = "This is #{plan} plan"
      subscription_plan.features = features
      subscription_plan.status = :active
    end

    billing_cycles.each do |billing_cycle|
      SubscriptionPackage.find_or_create_by(subscription_plan: subscription_plan, billing_cycle: billing_cycle) do |subscription_package|
        subscription_package.price = base_price * (index + 1)
        subscription_package.billing_duration = 1
        subscription_package.status = :active
      end
    end
  end
end

ActiveRecord::Base.transaction do
  # generate sample data for users
  number_of_users = 10
  number_of_companies = 10

  number_of_users.times do |index|
    user = User.find_or_create_by(email: "user#{index + 1}@example") do |user|
      user.password = 'password'
      user.password_confirmation = 'password'
      user.name = "User #{index + 1}"
    end

    # generate sample data for companies
    number_of_companies.times do |index|
      company = Company.find_or_create_by(name: "Company #{index + 1}") do |company|
        company.email = "company#{index + 1}@example"
      end
  
      user.update(active_company: company)
      company.users << user
    end
  end

  Company.all.each do |company|
    # generate sample data for subscriptions
    subscription_package = SubscriptionPackage.joins(:subscription_plan)
      .find_by(subscription_plan: { name: 'Free' })
    Subscription.find_or_create_by(company: company, subscription_package: subscription_package) do |subscription|
      subscription.price = subscription_package.price
      subscription.start_date = Date.today
      subscription.end_date = subscription_package.end_date_from_now
      subscription.billing_cycle = subscription_package.billing_cycle
      subscription.billing_duration = subscription_package.billing_duration
      subscription.status = :active
    end
  end
end