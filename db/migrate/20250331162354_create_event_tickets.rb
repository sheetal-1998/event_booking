class CreateEventTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :event_tickets do |t|
      t.references :event, null: false, foreign_key: true
      t.string :ticket_type
      t.decimal :price
      t.integer :available_seats

      t.timestamps
    end
  end
end
