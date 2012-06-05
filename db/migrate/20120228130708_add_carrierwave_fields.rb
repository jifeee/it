class AddCarrierwaveFields < ActiveRecord::Migration
  def self.up
    add_column :milestones, :doc, :string
    add_column :signatures, :signature, :string
  end

  def self.down
    remove_column :milestones, :doc
    remove_column :signatures, :signature
  end
end
