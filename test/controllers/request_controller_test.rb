require 'test_helper'

class RequestControllerTest < ActionDispatch::IntegrationTest
  test "should get confirm" do
    get request_confirm_url
    assert_response :success
  end

end
