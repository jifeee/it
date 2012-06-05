class CreateSignatures < ActiveRecord::Migration
  def self.up
    create_table :signatures do |t|
      t.references :milestone
      t.string :name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :signatures
  end
end
