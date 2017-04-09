require 'test_helper'

class Admin::FamilyControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_family_index_url
    assert_response :success
  end

end
