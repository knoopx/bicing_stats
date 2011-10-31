class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.belongs_to :station
      t.integer :used, :default => 0
      t.integer :unused, :default => 0
      t.timestamps
    end
  end
end
