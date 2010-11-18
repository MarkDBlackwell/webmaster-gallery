class RenameWeightToPrecedence < ActiveRecord::Migration
  def self.up
    rename_column :pictures, :weight, :precedence
  end

  def self.down
    rename_column :pictures, :precedence, :weight
  end
end
