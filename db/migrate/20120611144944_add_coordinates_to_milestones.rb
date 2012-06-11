class AddCoordinatesToMilestones < ActiveRecord::Migration
  def self.up
    add_column :milestones, :latitude, :float, :limit => "10,6", :default => 0
    add_column :milestones, :longitude, :float, :limit => "10,6", :default => 0
  end

  def self.down
    remove_column :milestones, :longitude
    remove_column :milestones, :latitude
  end
end
