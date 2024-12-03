require 'rgeo'

class County < ApplicationRecord
  @@parser = RGeo::WKRep::WKBParser.new Place.factory, default_srid: 4326, support_ewkb: true

  scope :for_place, -> (place) { where("ST_Contains(ST_SetSRID(polygon::geometry, 4326), ST_GeomFromText(?, 4326))", place.lonlat) }
end
