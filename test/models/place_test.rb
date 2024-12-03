require "test_helper"

class PlaceTest < ActiveSupport::TestCase  
  test "place must have a latitude-longitude pair" do
    p = Place.new(lonlat: nil)
    refute p.save

    p = Place.new(lonlat: "")
    refute p.save
  end
  
  test "newly instantiated place is always in review" do
    p = Place.new
    assert_equal p.published_status, Place::PUBLISHED_STATUS_IN_REVIEW
  end

  test "newly created place must have a code" do
    c = create(:county)
    p = create(:place)
    
    refute_nil p.code
    assert p.code.starts_with? c.code
  end

  test "create place with a repeated code must raise" do
    first_place = build(:place)
    first_place.expects(:calculate_code).returns("TEST")
    first_place.save

    second_place = build(:place)
    second_place.expects(:calculate_code).returns("TEST")

    assert_raises(ActiveRecord::RecordNotUnique) {
      second_place.save
    }
  end
end
