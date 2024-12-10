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

  test "source DIA is invalid without link" do
    ["", nil].each do |invalid_link|
      s = Source.new(kind: Source::KIND_DIA, link: invalid_link, place: @place)
      refute s.valid?
    end
  end

  test "Source#build_args_from_str returns expected sources when valid strings are passed" do
    actual = Source.build_args_from_str "insta::https://www.instagram.com/p/something/:: gstreet::https://www.google.com/maps/@something::"
    assert_kind_of Array, actual
    assert_equal actual.size, 2
    assert_kind_of Hash, actual[0]
    assert_kind_of Hash, actual[1]
    assert_equal actual[0][:kind], Source::KIND_INSTAGRAM
    assert_equal actual[1][:kind], Source::KIND_GOOGLE_STREETVIEW
  end

  test "Source#build_args_from_str returns empty for unknown sources" do
    actual = Source.build_args_from_str "unknown::https://unknown_source::"
    assert_empty actual
  end
end
