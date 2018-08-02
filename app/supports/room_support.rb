class RoomSupport
  attr_accessor :movie, :screening, :room

  def initialize screening
    @screening = screening
    @movie = screening.movie
    @room = screening.room
  end

  def room_map
    @room.map
  end

  def movie_id
    @movie.id
  end

  def screening_id
    @screening.id
  end

  def room_id
    @room.id
  end

  def sold
    @screening.sold_seats
  end
end