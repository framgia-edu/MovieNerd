class SchedulesController < ApplicationController
  def index
    @date = if params[:date]
              params[:date]
            else
              Date.today
            end
    @movie = Movie.movie_by_day @date
  end
end
