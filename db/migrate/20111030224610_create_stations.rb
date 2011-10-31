class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :used, :default => 0
      t.integer :unused, :default => 0
      t.belongs_to :sample
      t.timestamps
    end
  end
end
