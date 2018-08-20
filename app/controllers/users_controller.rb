class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update, :show]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_mail
      flash[:success] = t "activate_mail.noti"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    redirect_to root_url unless @user.activated?
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "flash.updated"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
