class Sample < ActiveRecord::Base
  belongs_to :station
  validates_presence_of :station

  scope :hourly, lambda {
    select { [created_at, AVG(used).as(:used), AVG(unused).as(:unused)] }.
        group { [HOUR(created_at), YEAR(created_at), MONTH(created_at), DAY(created_at)] }
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

  after_create do
    self.station.update_attributes(:used => self.used, :unused => self.unused)
  end
end
