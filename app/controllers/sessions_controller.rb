class SessionsController < ApplicationController

  def new
    redirect_to new_user_url
  end

  def create
    puts "++++++++++CREATING A SESSION"

    if ( !params[:email].present? or !params[:password].present? )
       return redirect_to home_url, notice: 'You are missing an email or password'
     end

    @user = User.find_by_email(params[:email]) if User.find_by_email(params[:email]).present?
    @user ||= User.find_by_username(params[:email])
    
    if not @user.present?
      puts "Failed when searching for username"
      redirect_to home_url, notice: "That username/email does not exist."
      return
    end

    auth = @user.authenticate(params[:password])
    if auth
      session[:user_id] = @user.id
      redirect_to home_url, notice: 'Signed in successfully'
    else
      redirect_to home_url, notice: "Incorrect password for that username/email."
    end
  end

  def destroy
    reset_session
    redirect_to home_url, notice: 'Signed out successfully'
  end
end
