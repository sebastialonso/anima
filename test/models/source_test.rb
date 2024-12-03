require "test_helper"

class SourceTest < ActiveSupport::TestCase

  setup do
    @place = build(:place)
  end

  test "source with invalid kind is invalid" do
    s = Source.new(kind: "INVALID", place: @place)
    refute s.valid?
  end

  test "source Street View is invalid without link" do
    ["", nil].each do |invalid_link|
      s = Source.new(kind: Source::KIND_GOOGLE_STREETVIEW, link: invalid_link, place: @place)
      refute s.valid?
    end
  end

  test "source Instagram is invalid without link" do
    ["", nil].each do |invalid_link|
      s = Source.new(kind: Source::KIND_INSTAGRAM, link: invalid_link, place: @place)
      refute s.valid?
    end
  end
end
