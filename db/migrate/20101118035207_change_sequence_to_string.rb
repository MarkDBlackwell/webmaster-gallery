class ChangeSequenceToString < ActiveRecord::Migration
  def self.up
    change_column :pictures, :sequence, :string, :limit => 4
  end

  def self.down
    change_column :pictures, :sequence, :integer
  end
end
