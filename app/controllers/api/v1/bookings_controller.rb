class Api::V1::BookingsController < ApplicationController

  before_action :authorize_customer!, only: [:create, :update, :destroy, :customer_bookings]
  before_action :set_booking, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  def index
    @bookings = Booking.all
    render json: @bookings, status: :ok
  end

  def customer_bookings
    @bookings = current_user.bookings
    render json: @bookings, status: :ok
  end

  def create
    @booking = current_user.bookings.new(booking_params)
    if @booking.save
      render json: @booking, status: :created
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @booking, status: :ok
  end

  def update
    if @booking.update(booking_params)
      render json: @booking, status: :ok
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @booking.destroy
      render json: @booking, status: :ok
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end


  def booking_params
    params.require(:booking).permit(:event_ticket_id, :number_of_seats)
  end

end