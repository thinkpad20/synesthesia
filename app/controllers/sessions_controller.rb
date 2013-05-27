class SessionsController < ApplicationController
  def new
    redirect_to new_user_url
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user.present? && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to home_url, notice: 'Signed in successfully.'
    else
      redirect_to new_user_url
    end
  end

  def destroy
    reset_session
    redirect_to home_url, notice: 'Signed out successfully.'
  end
end
