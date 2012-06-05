class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :phone
      t.string :ext
      t.string :zip
      
      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
