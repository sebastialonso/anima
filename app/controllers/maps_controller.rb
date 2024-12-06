class MapsController < ApplicationController
  def index
    @places = parse_places Place.all
    @counties = County.pluck(:name, :code).uniq.sort_by {|x| x[0] }
  end

  private
  def parse_places places
    places.map do |place|
      { "point" => place.to_latlon, "id" => place.code }
    end.to_json
  end
end
