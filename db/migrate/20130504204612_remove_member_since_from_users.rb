class RemoveMemberSinceFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :member_since
  end

  def down
    add_column :users, :member_since, :string
  end
end
