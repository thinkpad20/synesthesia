class User < ActiveRecord::Base
	include ActiveModel::Validations
	attr_accessible :email, :full_name, :password_hash, :username, :avatar

	validates :username,
						:presence => true,
						:length => { :maximum => 50 }

	has_many :images, dependent: :destroy
	has_many :likes

	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
 	has_many :followed_users, through: :relationships, source: :followed
 	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  	has_many :followers, through: :reverse_relationships, source: :follower


	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/assets/:style/missing.png", dependent: :destroy

	def self.validate_email(addr)
		if not addr.present?
			return {message: "cannot be blank"}
		end

		if (not addr.count('@') == 1) || (addr.include?('..')) || (not addr.include?('.'))
			return {message: "is not valid"}
		end

		@user = User.find_by_email(addr)

		if @user.present?
			return { message: "is already taken", case_sensitive: false }
		end

		return nil
	end

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

	def num_files
		return Image.where(:user_id => self.id).count
	end

	def self.last_n(n)
  		return User.order("created_at DESC").limit(n)
  	end

  	#returns users syneths as a "tuple" of image and corresponded sound
  	def get_syneths
  		res = []
  		images.order("updated_at DESC").each do |image|
  			res << [image, image.sounds[0]]
  		end
  		puts res
  		return res
  	end

  	def following?(other_user)
    		relationships.find_by_followed_id(other_user.id)
  	end

  	def follow!(other_user)
    		relationships.create!(followed_id: other_user.id)
  	end

  	def unfollow!(other_user)
    		relationships.find_by_followed_id(other_user.id).destroy
  	end
end
