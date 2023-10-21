class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.references :owner, foreign_key: { to_table: :users }, type: :bigint
      t.string :name, null: false, default: ""
      t.string :email
      t.string :phone
      t.text :address

      t.timestamps
    end

    add_index :companies, :email, unique: true
  end
end
