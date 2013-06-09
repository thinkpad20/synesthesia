class Comment < ActiveRecord::Base
  attr_accessible :content, :sound_id, :user_id
  
  belongs_to :user
  belongs_to :sound
end
