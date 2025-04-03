class AddDeviseTokenAuthToUsers < ActiveRecord::Migration[8.0]
  def change
    change_table(:users) do |t|
      ## Required for Devise Token Auth
      t.string :provider, null: false, default: "email"
      t.string :uid, null: false, default: ""

      ## Tokens for authentication
      t.text :tokens

      # Add an index for better query performance
      t.index [:uid, :provider], unique: true
    end
  end
end
