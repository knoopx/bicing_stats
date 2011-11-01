class AddIndexesToSamples < ActiveRecord::Migration
  def change
    add_index :samples, :created_at
    add_index :samples, [:used, :unused, :created_at], :name => 'index_samples_on_used_unused_created_at'
  end
end
