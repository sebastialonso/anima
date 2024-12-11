require "test_helper"

class MapControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mapa_index_url
    assert_response :success
  end
end
