class AddWeight < ActiveRecord::Migration
  def self.up
    add_column :pictures, :weight, :string, :limit => 2
  end

  def self.down
    remove_column :pictures, :weight
  end
end
