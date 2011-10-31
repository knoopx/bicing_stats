class Sample < ActiveRecord::Base
  belongs_to :station
  validates_presence_of :station

  after_create do
    self.station.update_attributes(:used => self.used, :unused => self.unused)
  end
end
