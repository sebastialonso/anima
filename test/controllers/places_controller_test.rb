require "test_helper"

class PlacesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get animitas_url
    
    assert_response :success
    assert_not_nil assigns(:in_review)
    assert_not_nil assigns(:same_place)
    assert_not_nil assigns(:in_close_proximity)
  end

  test "should get show" do
    county = create(:county)
    place = create(:place, code: "DOÑI11111")
    source = create(:source, place: place)
    source = create(:source, kind: Source::KIND_INSTAGRAM, link: "insta_link", place: place)

    get animita_url(id: place.code)
    
    assert_response :success
    assert_not_nil assigns(:place)

    assert_select "#place-code", place.code
    assert_select "#county-box", /#{county.name}.*/
    assert_select "#county-box", /#{county.region_display}.*/


    assert_select "ul#sources-list" do
      assert_select "li#source", {count: 2}
      assert_select "li a", { text: "Ver", count: place.sources.size }
    end
  end

  test "should patch approve" do
    place = create(:place, code: "DOÑI11111")
    
    patch approve_animita_url(id: place.code)
    
    assert_not_nil assigns(:place)
    place.expects(:approve).at_most_once
    assert_equal JSON.parse(response.body), {"success" => true}

    # TODO test when fails
  end

  test "should patch reject when format is json" do
    place = create(:place, code: "DOÑI11111")

    patch reject_animita_url(id: place.code)
    
    assert_not_nil assigns(:place)
    place.expects(:reject).at_most_once
    assert_equal JSON.parse(response.body), {"success" => true}

    # TODO test when fails
  end
end
