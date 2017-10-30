require 'test_helper'

class Admin::AdminParticipantsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get admin_participants_url
    assert_response :success
  end

  test "should get show" do
    get admin_participants_show_url
    assert_response :success
  end

end
