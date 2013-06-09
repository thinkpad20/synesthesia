class Sound < ActiveRecord::Base
  attr_accessible  :name, :url, :image_id

  after_destroy :delete_sound_resource

  has_many :likes
  belongs_to :image
  has_many :comments

  private
    def delete_sound_resource
   	FileUtils.rm self.url
    end

end
