require 'open-uri'

class Station < ActiveRecord::Base
  attr_accessible :id, :latitude, :longitude, :name, :address, :used, :unused
  has_many :samples, :dependent => :delete_all

  acts_as_gmappable

  def gmaps
    true
  end


  def gmaps4rails_address
    self.address
  end

  def gmaps4rails_infowindow
    self.name
  end

  def usage
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('number', 'Age')
    data_table.new_column('number', 'Weight')
    data_table.add_rows(6)
    data_table.set_cell(0, 0, 8)
    data_table.set_cell(0, 1, 12)
    data_table.set_cell(1, 0, 4)
    data_table.set_cell(1, 1, 5.5)
    data_table.set_cell(2, 0, 11)
    data_table.set_cell(2, 1, 14)
    data_table.set_cell(3, 0, 4)
    data_table.set_cell(3, 1, 4.5)
    data_table.set_cell(4, 0, 3)
    data_table.set_cell(4, 1, 3.5)
    data_table.set_cell(5, 0, 6.5)
    data_table.set_cell(5, 1, 7)
  end


  class << self
    def download(sample = false)
      list = open("http://pas.tempos21.com/BicingiPhone/UpdateStatus?fu=1").read
      Station.transaction do
        list.each_line do |line|
          station_attrs = {}
          sample_attrs = {}
          station_attrs[:id], station_attrs[:longitude], station_attrs[:latitude], unknown, station_attrs[:name], unkown2, station_attrs[:address], sample_attrs[:used], sample_attrs[:unused] = line.chomp.split("|")
          next if station_attrs[:id] == "null"
          station = self.find_or_create_by_id(station_attrs)
          station.samples.create(sample_attrs) if sample
        end
      end
      true
    end
  end
end
