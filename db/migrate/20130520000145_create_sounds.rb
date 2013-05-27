class CreateSounds < ActiveRecord::Migration
  def change
    create_table :sounds do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :algorithm_name

      t.timestamps
    end
  end
end
