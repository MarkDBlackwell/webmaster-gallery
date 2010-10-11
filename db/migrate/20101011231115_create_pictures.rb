class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string :filename
      t.integer :sequence
      t.string :title
      t.string :year
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
