class ShowingsController < ApplicationController
  def index
    @movies = Movie.showing.page(params[:page]).per Settings.admin.per_page
  end
end
