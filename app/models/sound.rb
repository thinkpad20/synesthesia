class Sound < ActiveRecord::Base
  attr_accessible  :name, :url

  has_many :likes
  belongs_to :image

end
