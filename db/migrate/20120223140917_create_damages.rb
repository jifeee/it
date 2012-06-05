class CreateDamages < ActiveRecord::Migration
  def self.up
    create_table :damages do |t|
      t.references :milestone
      t.string :photo

      t.timestamps
    end
  end

  def self.down
    drop_table :damages
  end
end
