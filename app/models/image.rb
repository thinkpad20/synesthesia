class Image < ActiveRecord::Base
  attr_accessible :description, :name, :url, :file

  belongs_to :user
  has_many :sounds

  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/assets/:style/missing.png"

  def self.last_n(n, user_id = nil)
  	if user_id.present?
  		return Image.where(:user_id => user_id).order("created_at DESC").limit(n)
  	else
  		return Image.order("created_at DESC").limit(n)
  	end
  end
end
