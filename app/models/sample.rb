class Sample < ActiveRecord::Base
  belongs_to :station
  validates_presence_of :station

  scope :hourly, lambda {
    select { [
        :station_id,
        MIN(created_at).as(:created_at),
        AVG(used).as(:used),
        AVG(unused).as(:unused),
        MAX(used).as(:max_used),
        MAX(unused).as(:max_unused),
        MIN(used).as(:min_used),
        MIN(unused).as(:min_unused)
    ] }.group { [:station_id, HOUR(created_at), YEAR(created_at), MONTH(created_at), DAY(created_at)] }.
        reorder("created_at DESC")
  }

  scope :punchcard, lambda {
    select { [
        WEEKDAY(created_at).as(:day),
        HOUR(created_at).as(:hour),
        AVG(used).as(:used),
        AVG(unused).as(:unused),
        MAX(used).as(:max_used),
        MAX(unused).as(:max_unused),
        MIN(used).as(:min_used),
        MIN(unused).as(:min_unused),
        STDDEV(used).as(:used_concurrency),
        STDDEV(unused).as(:unused_concurrency)
    ] }.group { [WEEKDAY(created_at), HOUR(created_at)] }
  }

  def self.aggregate!
    self.transaction do
      self.hourly.each do |sample|
        attributes = sample.attributes
        attributes["created_at"] = sample.created_at.change(:min => 0, :sec => 0, :usec => 0)
        HourlySample.create!(attributes)
      end
    end
  end

  after_create do
    self.station.update_attributes(:used => self.used, :unused => self.unused)
  end
end
