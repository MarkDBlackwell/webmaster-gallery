class CreateFileTags < ActiveRecord::Migration
  def self.up
    create_table :file_tags do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :file_tags
  end
end
