class RenamePrecedenceBackToWeight < ActiveRecord::Migration
  def self.up
    rename_column :pictures, :precedence, :weight
  end

  def self.down
    rename_column :pictures, :weight, :precedence
  end
end
