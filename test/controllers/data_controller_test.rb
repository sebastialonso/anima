require "test_helper"

class DataControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get data_url
    assert_response :success
    assert_not_nil assigns(:places)
  end
end
