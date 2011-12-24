class HourlySample < ActiveRecord::Base
  belongs_to :station
  validates_presence_of :station

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

  default_scope order("created_at DESC")
end
