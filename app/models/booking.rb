class Booking < ApplicationRecord
  belongs_to :customer, class_name: "User"
  belongs_to :event_ticket

  validates :number_of_seats, :amount, presence: true
  validate :ticket_type_available, on: [:create, :update]
  before_validation :calculate_amount_and_available_seats
  before_destroy :update_available_seats_of_event_tickets
  after_create :send_booking_confirmation

  private

  def calculate_amount_and_available_seats
    self.amount = event_ticket.price * number_of_seats
    available_seats = self.new_record? ? event_ticket.available_seats - number_of_seats : event_ticket.available_seats - number_of_seats + number_of_seats_was
    event_ticket.update(available_seats: available_seats)
  end

  def update_available_seats_of_event_tickets
    event_ticket.update(available_seats: event_ticket.available_seats + number_of_seats)
  end

  def send_booking_confirmation
    BookingConfirmationJob.perform_later(id)
  end

  def ticket_type_available
    if event_ticket.present? && number_of_seats > event_ticket.available_seats
      errors.add(:number_of_seats, "not available for this event ticket type (only #{event_ticket.available_seats} left)")
    end
  end
end
