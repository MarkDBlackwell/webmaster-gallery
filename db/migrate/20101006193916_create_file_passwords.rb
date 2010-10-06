class CreateFilePasswords < ActiveRecord::Migration
  def self.up
    create_table :file_passwords do |t|
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :file_passwords
  end
end
