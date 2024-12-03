class DataController < ApplicationController
  def index
    @places = Place.includes(:sources).all
    
    respond_to do |format|
      format.json
    end
  end
end
