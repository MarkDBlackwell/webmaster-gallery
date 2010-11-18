class ChangeYearToString < ActiveRecord::Migration
  def self.up
    change_column :pictures, :year, :string, :limit => 4
  end

  def self.down
    change_column :pictures, :year, :integer
  end
end
