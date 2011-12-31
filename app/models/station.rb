require 'open-uri'

class Station < ActiveRecord::Base
  attr_accessible :id, :latitude, :longitude, :name, :address, :used, :unused
  has_many :hourly_samples, :dependent => :delete_all

  validates_presence_of :name, :address, :latitude, :longitude

  scope :unavailable, lambda { where(:used => 0, :unused => 0) }

  default_scope order(:name)

  class << self
    def update
      list = open("http://pas.tempos21.com/BicingiPhone/UpdateStatus?fu=1").read
      Station.transaction do
        list.each_line do |line|
          id, longitude, latitude, unknown, name, unknown2, address, used, unused = line.chomp.split("|")

          next if id == "null"

          station = self.find_or_create_by_id(
              :id => id,
              :name => name,
              :address => address,
              :longitude => longitude,
              :latitude => latitude,
              :used => used,
              :unused => unused
          )

          station.update_attributes(:used => used, :unused => unused)

          station.aggregate!(used, unused)
        end
      end
      true
    end
  end

  def aggregate!(used, unused)
    created_at = DateTime.now.change(:min => 0, :sec => 0, :usec => 0)
    if sample = self.hourly_samples.find_by_created_at(created_at)
      HourlySample.where(:id => sample.id).update_all(
          ["sum_used = sum_used + :used, max_used = GREATEST(IFNULL(max_used, :used), :used), min_used = LEAST(IFNULL(min_used, :used), :used),
            sum_unused = sum_unused + :unused, max_unused = GREATEST(IFNULL(max_unused, :unused), :unused), min_unused = LEAST(IFNULL(min_unused, :unused), :unused),
            sample_count = sample_count + 1, used = sum_used / sample_count, unused = sum_unused / sample_count", :used => used, :unused => unused],
      )
    else
      self.hourly_samples.create(:created_at => created_at, :used => used, :unused => unused, :sample_count => 1)
    end
  end
end
