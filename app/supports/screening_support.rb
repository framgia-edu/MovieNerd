class ScreeningSupport
  attr_reader :movie
  attr_reader :room

  def initialize movie, room = nil
    room ||= Room.first
    @movie = movie
    @room = room
  end

  def rooms
    Room.all
  end

  def movie_title
    @movie.title
  end

  def screenings_by_movie
    @movie.screenings.not_show_yet
  end

  def screenings_by_room
    @room.screenings.not_show_yet
  end
end
