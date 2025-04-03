class BookingConfirmationJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find(booking_id)
    puts "📧 Sending email confirmation to #{booking.customer.email} for event '#{booking.event_ticket.event.event_name}'"
  end
end
