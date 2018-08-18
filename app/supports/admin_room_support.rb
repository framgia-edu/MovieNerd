class AdminRoomSupport
  attr_accessor :row_num, :max_seat_per_row, :deleted_seats, :room, :map

  def initialize room, map
    @room = room
    @row_num = @room.row_num
    @max_seat_per_row = @room.max_seat_per_row
    @deleted_seats = @room.find_deleted_seats
    @map = map
  end
end
