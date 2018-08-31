class RoomsController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :load_support, only: [:show]

  def show
    @order = Order.new
    @selected_seats = []
  end

  private

  def load_support
    if params[:screening_id]
      screening = Screening.find_by id: params[:screening_id]
      redirect_to root_url unless params[:id] == screening.room_id.to_s

      @support = RoomSupport.new screening
    else
      redirect_to root_url
    end
  end
end
