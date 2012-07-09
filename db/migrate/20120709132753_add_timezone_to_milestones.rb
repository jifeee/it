class AddTimezoneToMilestones < ActiveRecord::Migration
  def self.up
  	add_column 'milestones', :timezone, :decimal, :precision => 2, :scale => 1, :default => 0
  end

  def self.down
  	remove_column 'milestones', :timezone
  end
end
