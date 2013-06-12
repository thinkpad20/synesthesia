require 'password_hash'

class ApplicationController < ActionController::Base
	include PasswordHash
	protect_from_forgery
	helper_method :signed_in?
	helper_method :current_user
	before_filter :require_login

	def require_login
		if (self.class == UsersController || self.class == ImagesController)
			&& (self.action == "edit" || self.action == "create")
			unless signed_in?
				flash[:error] = "You must be logged in to access this section"
				redirect_to home_url
			end
		end
	end

	def signed_in?
		return session[:user_id].present? && User.find_by_id(session[:user_id]).present?
	end

	def current_user
		return @current_user ||= User.find_by_id(session[:user_id])
	end

end
