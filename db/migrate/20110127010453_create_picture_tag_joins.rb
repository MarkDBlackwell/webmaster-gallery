class CreatePictureTagJoins < ActiveRecord::Migration
  def self.up
    create_table :picture_tag_joins do |t|
      t.integer :picture_id
      t.integer :tag_id
# Not use indexes, because the users see cached pages.

      t.timestamps
    end
  end

  def self.down
    drop_table :picture_tag_joins
  end
end
