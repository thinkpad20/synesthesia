class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_hash
      t.string :email
      t.string :full_name
      t.datetime :member_since

      t.timestamps
    end
  end
end
