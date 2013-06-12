require 'password_hash'

class ApplicationController < ActionController::Base
	include PasswordHash
	protect_from_forgery
	helper_method :signed_in?
	helper_method :current_user
	before_filter :require_login, :only => [ :edit, :update, :create, :new ]

	def require_login
		unless signed_in?
			redirect_to home_url,  notice: "You must be logged in to access this section"
		end
	end

	def signed_in?
		return session[:user_id].present? && User.find_by_id(session[:user_id]).present?
	end

	def current_user
		return @current_user ||= User.find_by_id(session[:user_id])
	end

end
