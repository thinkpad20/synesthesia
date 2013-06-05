class Comment < ActiveRecord::Base
  attr_accessible :content, :sound_id, :user_id
end
