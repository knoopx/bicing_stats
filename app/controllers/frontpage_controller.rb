class FrontpageController < ApplicationController
  def index
    @stations = Station.all
    @map = @stations.to_gmaps4rails

    @total_bikes = Station.sum(:used)
    @total_slots = Station.sum(:unused)
  end
end