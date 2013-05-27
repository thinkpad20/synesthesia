class User < ActiveRecord::Base

	validates_presence_of :username, :email
	attr_accessible :email, :full_name, :password_hash, :username

	has_many :images
	has_many :likes

	def authenticate(password)
		hash = password_hash
		return PasswordHash.validatePassword(password, hash)
	end

	#params SC access_token hash
	#stores in user table
	def store_soundcloud_info(access_token)
	end
end
