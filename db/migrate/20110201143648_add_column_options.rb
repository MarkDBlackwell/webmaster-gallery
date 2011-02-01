class AddColumnOptions < ActiveRecord::Migration
  def self.up
    change_table :pictures do |t|
      t.remove :sequence, :weight
      t.string :sequence   
      t.string :weight, :default => '0'
    end
    change_table :picture_tag_joins do |t|
      t.remove :picture_id, :tag_id
      t.references :picture, :tag
    end
  end

  def self.down
    change_table :pictures do |t|
      t.remove :sequence, :weight
      t.string :sequence, :limit => 4
      t.string :weight,   :limit => 2
    end
    change_table :picture_tag_joins do |t|
      t.remove :picture_id, :tag_id
      t.integer :picture_id
      t.integer :tag_id
    end
  end
end
