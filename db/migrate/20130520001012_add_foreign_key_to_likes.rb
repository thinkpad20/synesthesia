class AddForeignKeyToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :user_id, :integer
    add_column :likes, :sound_id, :integer
  end
end
