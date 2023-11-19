module Subscriptionable
  # shared enums for subscription package and subscription
  extend ActiveSupport::Concern

  included do
    enum billing_cycle: {
      weekly: 1,
      monthly: 2,
      annually: 3,
      one_time: 4
    }, _default: 'monthly'
  end
end