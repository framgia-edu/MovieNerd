class OrdersController < ApplicationController
  before_action :find_user, only: [:show]
  before_action :correct_user, only: [:show]

  def show
    @order = Order.find_by id: params[:order_id]
  end

  def create
    user = current_user
    screening = Screening.find_by id: params[:screening_id]
    room = Room.find_by id: params[:room_id]
    ActiveRecord::Base.transaction do
      order = user.orders.create! screening_id: screening.id
      params_selected_seats.each do |seat_name|
        row, num = seat_name.split "_"
        seat = room.seats.find_by row: row, number: num
        order.movie_tickets.create! seat_id: seat.id, screening_id: params[:screening_id]
      end
      redirect_to order_url(user.id, order_id: order.id)
    end
    rescue
      create_error screening
  end

  private

  def load_support screening
    @support = RoomSupport.new screening
  end

  def screening_id
    params.require :screening_id
  end

  def params_selected_seats
    return [] if params[:selected_seats].nil?
    params.require(:selected_seats).split ","
  end

  def correct_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def create_error screening
    load_support screening
    @selected_seats = params_selected_seats - @support.sold
    flash.now[:danger] = t "flash.select_seat_failed"
    respond_to do |format|
      format.js
    end
  end
end
