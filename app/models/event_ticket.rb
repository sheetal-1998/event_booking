class EventTicket < ApplicationRecord
  belongs_to :event
  has_many :bookings, dependent: :destroy

  enum :ticket_type, { vip: "VIP", general: "General" }

  validates :ticket_type, :price, :available_seats, presence: true

end
