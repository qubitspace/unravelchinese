class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  skip_after_action :verify_authorized, only: [:new, :create, :destroy]

  def new
  end

  def create
    user = authenticate_session(session_params, email_or_username: [:email, :username])

    if user.email_confirmed
      if sign_in(user)
        redirect_to session_redirect_path
      else
        render :new
      end
    else
      sign_out
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to session_redirect_path
  end

  private

  def session_params
    params.require(:session).permit(:email_or_username, :password)
  end
end

