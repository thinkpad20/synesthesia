class User < ActiveRecord::Base
	include ActiveModel::Validations
	attr_accessible :email, :full_name, :password_hash, :username

	# validates_presence_of :username, :email

	validates :username,
						:presence => true,
						:length => { :maximum => 50 }
  	validates :email, 	:presence =>{message: "cannot be blank"},
  						:email => {message: "is not valid"},
  						uniqueness: { message: "is already taken", case_sensitive: false }

	has_many :images
	has_many :likes

	def authenticate(password)
		hash = password_hash
		return PasswordHash.validatePassword(password, hash)
	end

	def new?
		id.nil?
	end

	def username_taken?
		self.class.exists?(:username => username)
	end

	def email_taken?
		self.class.exists?(:email => email)
	end

end
