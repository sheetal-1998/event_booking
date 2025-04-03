class EventUpdateNotificationJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find(event_id)
    bookings = Booking.joins(:event_ticket).where(event_tickets: { event_id: event.id })
    customers = bookings.map(&:customer).uniq
    customers.each do |customer|
      puts "📧 Notifying #{customer.email} about updates to event '#{event.event_name}'"
    end
  end
end

