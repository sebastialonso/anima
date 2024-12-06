class PlacesController < ApplicationController
  before_action :require_user!, only: [:index]
  before_action :set_place, only: [:show, :approve, :reject]
  
  def index
    @in_review = Place.in_review()
    @in_close_proximity = Place.in_close_proximity
    @same_place = Place.at_the_same_point
  end

  def show
  end

  def approve
    @place.approve
    respond_to do |f|
      f.json { render :json => {success: true} }
    end
  end

  def reject
    @place.reject
    respond_to do |f|
      f.json { render :json => {success: true} }
    end
  end

  private
  def set_place
    @place = Place.find_by(code: params[:id])
  end
end
