class Api::V1::EventsController < ApplicationController

  before_action :authorize_organizer!, only: [:create, :update, :show, :destroy]
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  def index
    @events = Event.includes(:event_tickets).all
    render json: @events, include: :event_tickets, status: 200
  end

  def show
    render json: @event, include: :event_tickets, status: 200
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      render json: @event, include: :event_tickets, status: :created
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event, include: :event_tickets, status: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    render json: { message: "Event deleted successfully" }, status: :ok
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:event_name, :date, :venue, event_tickets_attributes: [:ticket_type, :price, :available_seats])
  end
end
