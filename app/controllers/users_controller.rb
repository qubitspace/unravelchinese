class UsersController < ApplicationController
  skip_after_action :verify_authorized, only: [:new, :create, :confirm_email]
  skip_before_action :require_login, only: [:new, :create, :confirm_email]

  def new
    @user = User.new
  end

  def create
    @user = sign_up(user_params)
    @user.username = user_params[:username]

    if @user.valid?
      UserMailer.registration_confirmation(@user).deliver
      redirect_to root_path
    else
      render :new
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      redirect_to new_session_path
    else
      redirect_to root_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end

