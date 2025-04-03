class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :mobile, :string
  end
end
