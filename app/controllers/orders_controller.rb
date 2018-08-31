class OrdersController < ApplicationController
  before_action :correct_user, only: [:show, :destroy]

  def index
    @orders = Order.page(params[:page])
                   .per Settings.admin.per_page
  end

  def create
    screening = Screening.find_by id: params[:screening_id]
    room = Room.find_by id: params[:room_id]
    if room && screening
      create_order screening, room
    else
      flash.now[:danger] = t "flash.smt_wrong"
      redirect_to root_url
    end
  end

  def show; end

  def destroy
    @order.really_destroy!
    redirect_to root_url
  end

  private

  def create_order screening, room
    ActiveRecord::Base.transaction do
      order = current_user.orders.create! screening: screening
      order.delete_unpaid
      raise ActiveRecord::RecordInvalid if params_selected_seats.empty?
      create_seats room, order
      redirect_to baokim(screening.movie.title, screening.movie.friendly_id,
        params_selected_seats.count, order.id)
    end
  rescue StandardError
    create_error screening
  end

  def create_seats room, order
    params_selected_seats.each do |seat_name|
      row, num = seat_name.split "_"
      seat = room.seats.find_by row: row, number: num
      order.movie_tickets.create! seat_id: seat.id,
        screening_id: params[:screening_id]
    end
  end

  def create_error screening
    @support = RoomSupport.new screening
    @selected_seats = params_selected_seats - @support.sold
    flash.now[:danger] = t "flash.select_seat_failed"
    respond_to do |format|
      format.js
    end
  end

  def params_selected_seats
    return [] if params[:selected_seats].nil?
    params[:selected_seats].split ","
  end

  def correct_user
    @order = if params[:id]
               Order.find_by id: params[:id]
             else
               Order.find_by id: params[:order_id]
             end
    authorize! :read, @order
    authorize! :destroy, @order
  end

  def baokim product_name, detail_movie, product_quantity, order_id
    business = ENV["EMAIL"]
    product_price = Settings.price_vnd
    total_amount = product_price * product_quantity
    url_detail = ENV["URL_DETAIL"] + detail_movie.to_s
    url_cancel =  ENV["URL_CANCEL"] + order_id.to_s
    url_success = ENV["URL_SUCCESS"] + order_id.to_s

    "https://www.baokim.vn/payment/product/version11?business="\
    "#{business}&id=&product_name="\
    "#{product_name}&product_price=#{product_price}&product_quantity="\
    "#{product_quantity}&total_amount=#{total_amount}&url_cancel="\
    "#{url_cancel}&url_detail=#{url_detail}&url_success=#{url_success}"
  end
end
