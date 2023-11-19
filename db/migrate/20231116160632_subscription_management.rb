class SubscriptionManagement < ActiveRecord::Migration[7.1]
  def change
    create_table :subscription_plans do |t|
      t.string  :name,          null: false
      t.string  :image
      t.string  :description,   null: false
      t.string  :features,      array: true, default: []
      t.integer :status,        null: false, default: 0
      t.timestamps
    end

    create_table :subscription_packages do |t|
      t.references :subscription_plan, foreign_key: true, type: :bigint
      t.integer :price,                null: false
      t.integer :billing_cycle,        null: false
      t.integer :billing_duration,     null: false
      t.integer :status,               null: false, default: 0
      t.timestamps
    end

    create_table :subscriptions do |t|
      t.references :subscription_package, null: false, foreign_key: true, type: :bigint
      t.references :company,              null: false, foreign_key: true, type: :bigint
      t.date :start_date,                 null: false
      t.date :end_date,                   null: false
      t.integer :price,                   null: false
      t.integer :billing_cycle,           null: false
      t.integer :billing_duration,        null: false
      t.integer :status,                  null: false, default: 0
      t.timestamps
    end

    create_table :invoices do |t|
      t.uuid :external_id,        null: false, default: 'gen_random_uuid()'
      t.references :invoiceable,  null: false, polymorphic: true
      t.references :user,         null: false, foreign_key: true, type: :bigint
      t.integer :total_amount,    null: false
      t.date :issue_date,         null: false
      t.date :due_date,           null: false
      t.integer :status,          null: false, default: 0
      t.string :payment_gateway
      t.string :payment_gateway_ref
      t.string :invoice_url
      t.string :invoice_number

      # payments detail
      t.integer :paid_amount,     default: 0
      t.date :paid_date
      t.string :payment_method
      t.timestamps
    end
  end
end
