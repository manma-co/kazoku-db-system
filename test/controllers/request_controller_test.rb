require 'test_helper'

class RequestControllerTest < ActionDispatch::IntegrationTest
  test "should get confirm" do
    get request/:id_path
    assert_response :success
  end

end
