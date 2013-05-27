class Sound < ActiveRecord::Base
  attr_accessible :algorithm_name, :description, :name, :url

  has_many :likes
  belongs_to :image

end
