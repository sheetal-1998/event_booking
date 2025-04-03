class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.references :organizer, null: false, foreign_key: { to_table: :users }
      t.string :event_name
      t.datetime :date
      t.string :venue

      t.timestamps
    end
  end
end
