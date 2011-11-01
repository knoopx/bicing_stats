class StationsController < ApplicationController
  def index
    @stations = Station.by_concurrency.all
  end

  def show
    @station = Station.find(params[:id])
    @map = StaticGmaps::Map.new(:center => [@station.latitude, @station.longitude], :zoom => 15, :size => [220, 300])
    @map.markers.clear
    @map.markers << StaticGmaps::Marker.new(:latitude => @station.latitude, :longitude => @station.longitude, :color => :red)
  end
end