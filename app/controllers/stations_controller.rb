class StationsController < ApplicationController
  def index
    @search = Station.search(params[:q])
    @stations = @search.result.page(params[:page])
  end

  def show
    @station = Station.find(params[:id])
  end
end