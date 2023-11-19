module SubscriptionServices
  class Create < ApplicationService
    def initialize(company, params)
      @company = company
      @params = params
    end

    def call
      subscription = @company.subscriptions.new(@params)
      subscription.save!
      subscription
    end

    private

    def create_subscription
      @subscription_package.subscriptions.create!(
        company: @company,
        start_date: Time.zone.now,
        end_date: @subscription_package.end_date_from_now,
        price: @subscription_package.price,
        max_users: @subscription_package.max_users,
        max_plans: @subscription_package.max_plans,
        status: :pending
      )
    end
  end
end