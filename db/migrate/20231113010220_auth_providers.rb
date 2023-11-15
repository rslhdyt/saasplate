class AuthProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :auth_providers do |t|
      t.string :name, null: false
      t.string :uid, null: false
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :auth_providers, %i[name uid], unique: true
  end
end
