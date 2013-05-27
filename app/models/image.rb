class Image < ActiveRecord::Base
  attr_accessible :description, :name, :url

  belongs_to :user
  has_many :sounds
end
