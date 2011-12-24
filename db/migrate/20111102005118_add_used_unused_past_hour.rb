class AddUsedUnusedPastHour < ActiveRecord::Migration
  def up
    add_column :stations, :used_past_hour, :integer, :default => 0
    add_column :stations, :unused_past_hour, :integer, :default => 0

    Station.all.each do |station|
      station.update_attributes :used_past_hour => station.samples.where { created_at >= 1.hour.ago }.average(:used),
                                :unused_past_hour => station.samples.where { created_at >= 1.hour.ago }.average(:unused)

    end
  end

  def down
    remove_column :stations, :used_past_hour
    remove_column :stations, :unused_past_hour
  end
end
