class Place < ApplicationRecord
  @@factory = RGeo::Geographic.spherical_factory(srid: 4326)

  PUBLISHED_STATUS_IN_REVIEW = "IN_REVIEW"
  PUBLISHED_STATUS_ACCEPTED = "ACCEPTED"
  PUBLISHED_STATUS_REJECTED = "REJECTED"
  PUBLISHED_STATUS_ALLOWED = [PUBLISHED_STATUS_IN_REVIEW, PUBLISHED_STATUS_ACCEPTED, PUBLISHED_STATUS_REJECTED]
  
  STATUS_ACTIVE = "ACTIVE"
  STATUS_DAMAGED = "DAMAGED"
  STATUS_GONE = "GONE"

  has_many :sources
  validates :published_status, inclusion: { in: PUBLISHED_STATUS_ALLOWED }
  validates :lonlat, presence: true
  validates :code, uniqueness: true
  before_create :set_code

  scope :in_review, -> () { where(published_status: PUBLISHED_STATUS_IN_REVIEW) }
  WITHIN_METERS = "SELECT p1.code AS item, p2.code AS hits from places p1 JOIN places p2 ON ST_DWITHIN(p1.lonlat, p2.lonlat, 14) AND p1.id <> p2.id AND p2.published_status != 'REJECTED';"
  SAME_POINT_QUERY = "SELECT p1.code AS item, p2.code AS hits from places p1 JOIN places p2 ON ST_EQUALS(p1.lonlat::geometry, p2.lonlat::geometry) AND p1.id != p2.id AND p2.published_status != 'REJECTED';"

  def self.in_close_proximity()
    result = ActiveRecord::Base.connection.execute(WITHIN_METERS)
    result.inject({}) do |acc, el|
      tmp = acc.fetch(el["item"], [])
      tmp << el["hits"]
      
      acc.store(el["item"], tmp)
      acc
    end
  end

  def self.at_the_same_point
    result = ActiveRecord::Base.connection.execute(SAME_POINT_QUERY)
    result.inject({}) do |acc, el|
      tmp = acc.fetch(el["item"], [])
      tmp << el["hits"]
      
      acc.store(el["item"], tmp)
      acc
    end
  end

  def self.factory
    @@factory
  end

  def self.point(p)
    Place.factory.point(p.lonlat.x, p.lonlat.y)
  end

  def to_latlon
    [lonlat.y, lonlat.x]
  end

  def distance(p)
    Place.point(self).distance(Place.point(p))
  end

  def approve
    # TODO test validations
    self.update(published_status: PUBLISHED_STATUS_ACCEPTED)
  end

  def reject
    # TODO test validations
    self.update(published_status: PUBLISHED_STATUS_REJECTED)
  end

  def has_instagram_source?
    !sources.find_by(kind: Source::KIND_INSTAGRAM).nil?
  end

  def reformat_code_and_save
    county_code = County.for_place(self)[0].code
    self.update(code: "#{county_code}#{self.code[4..]}")
  end

  private
  def calculate_code
    county_code = "XXXX"
    county = County.for_place(self)
    if county.size > 0
      county_code = county[0].code
    end
    "#{county_code}#{rand(100_000..999_999)}"
  end

  def set_code
    self.code = calculate_code
  end
end
