class SchedulesController < ApplicationController
  def index
    @date = if params[:date]
              params[:date].to_date
            else
              Date.today
            end
    @movie = Movie.movie_by_day @date

    respond_to do |format|
      format.html
      format.js{render "schedules/index"}
    end
  end
end
