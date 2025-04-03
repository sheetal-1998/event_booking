class AddNumberOfSeatsToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :number_of_seats, :integer
    remove_column :bookings, :available_seats
  end
end
