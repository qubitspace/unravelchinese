class UsersController < ApplicationController
  skip_after_action :verify_authorized, only: [:new, :create]
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = sign_up(user_params)
    @user.username = user_params[:username]

    if @user.valid?
      sign_in(@user)
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end

