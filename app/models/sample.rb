class Sample < ActiveRecord::Base
  belongs_to :station
  validates_presence_of :station

  scope :punchcard, lambda {
    select { [
        DAYOFWEEK(created_at).as(:day),
        HOUR(created_at).as(:hour),
        AVG(used).as(:used),
        AVG(unused).as(:unused),
        STDDEV(used).as(:used_concurrency),
        STDDEV(unused).as(:unused_concurrency)
    ] }.
        group { [DAYOFWEEK(created_at), HOUR(created_at)] }
  }

  after_create do
    self.station.update_attributes(:used => self.used, :unused => self.unused)
  end
end
