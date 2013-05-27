class SessionsController < ApplicationController

  def new
    redirect_to new_user_url
  end

  def create

    if ( !params[:email].present? or !params[:password].present? )
       return redirect_to home_url, notice: 'You are missing an email or password'
     end

    @user = User.find_by_email(params[:email])

    if @user.present? && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to home_url, notice: 'Signed in successfully'
    else
      redirect_to home_url, notice: "We couldn't log you in, sure you had the right credentials?"
    end
  end

  def destroy
    reset_session
    redirect_to home_url, notice: 'Signed out successfully'
  end
end
