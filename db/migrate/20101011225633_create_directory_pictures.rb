class CreateDirectoryPictures < ActiveRecord::Migration
  def self.up
    create_table :directory_pictures do |t|
      t.string :filename
      t.integer :sequence
      t.boolean :has_thumbnail_file
      t.boolean :has_picture_file

      t.timestamps
    end
  end

  def self.down
    drop_table :directory_pictures
  end
end
