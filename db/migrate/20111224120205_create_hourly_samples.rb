class CreateHourlySamples < ActiveRecord::Migration
  def change
    create_table :hourly_samples do |t|
      t.belongs_to :station

      t.integer :used, :default => 0
      t.integer :unused, :default => 0
      t.integer :max_used, :default => 0
      t.integer :min_used, :default => 0
      t.integer :min_unused, :default => 0
      t.integer :max_unused, :default => 0

      t.timestamps
    end
  end
end
