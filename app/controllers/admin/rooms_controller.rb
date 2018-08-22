class Admin::RoomsController < Admin::BaseController
  def index
    @rooms = Room.page(params[:page]).per Settings.admin.per_page
  end

  def new
    @support = new_room %w(aaaaaa aaaaaa aaaaaa aaaaaa aaaaaa), []
  end

  def create
    @room = Room.new params_name
    set_map @room, params_map, params_deleted_seats
    if @room.save
      flash[:success] = t "flash.create_room_success"
      redirect_to admin_room_url(@room)
    else
      @support = new_room params_map, params_deleted_seats
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    @room = Room.find_by id: params[:id]
    return if @room
    redirect_to root_url
    flash[:danger] = t "flash.no_room"
  end

  private

  def params_name
    params.require(:room).permit :name
  end

  def params_map
    params.require(:field_map).split ","
  end

  def params_deleted_seats
    params[:field_deleted_seats].split ","
  end

  def new_room map, deleted_seats
    room = Room.new
    set_map room, map, deleted_seats
    row_num = room.row_num
    max_seat_per_row = room.max_seat_per_row
    deleted_seats ||= []
    AdminRoomSupport.new room, row_num, max_seat_per_row, deleted_seats, map
  end

  def set_map room, map, deleted_seats
    map.each_with_index do |row, row_index|
      row.split("").each_with_index do |pos, pos_index|
        next unless pos == "a"
        next if deleted_seats.include? "#{row_index + 1}_#{pos_index + 1}"
        room.seats.build row: row_index + 1, number: pos_index + 1
      end
    end
    room.seat_no = room.seats.size
  end
end
