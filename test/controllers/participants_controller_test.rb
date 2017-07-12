require 'test_helper'

class ParticipantsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get participants_index_url
    assert_response :success
  end

  test "should get show" do
    get participants_show_url
    assert_response :success
  end

end
