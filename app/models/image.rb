class Image < ActiveRecord::Base
  attr_accessible :description, :name, :url

  belongs_to :user
  has_many :sounds
  def self.last_n(n, user_id = nil)
  	if user_id.present?
  		return Image.where(:user_id => user_id).order("created_at DESC").limit(n)
  	else
  		return Image.order("created_at DESC").limit(n)
  	end
  end
end