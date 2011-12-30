class StationsController < ApplicationController
  def index
    @stations = Station.page(params[:page])
  end

  def show
    @station = Station.find(params[:id])
  end
end