class AddForeignKeyToSounds < ActiveRecord::Migration
  def change
    add_column :sounds, :image_id, :integer
  end
end
