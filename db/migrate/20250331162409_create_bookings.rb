class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :customer, null: false, foreign_key: { to_table: :users }
      t.references :event_ticket, null: false, foreign_key: true
      t.integer :available_seats, default: 0
      t.decimal :amount

      t.timestamps
    end
  end
end
