class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User"
  has_many :event_tickets, dependent: :destroy

  validates :event_name, :date, :venue, presence: true
  accepts_nested_attributes_for :event_tickets, allow_destroy: true
  after_update :send_event_update_notification

  private

  def send_event_update_notification
    EventUpdateNotificationJob.perform_later(self.id)
  end
end
