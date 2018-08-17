class ComingsController < ApplicationController
  def index
    @movies = Movie.coming.page(params[:page]).per Settings.admin.per_page
  end
end
