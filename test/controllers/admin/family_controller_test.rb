require 'test_helper'

class Admin::FamilyControllerTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    @admin = admins(:fuga)
    login_as(@admin, scope: :admin)
  end

  test 'should get index' do
    get admin_family_url
    assert_response :success
  end

end
