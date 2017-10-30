require 'test_helper'

class Admin::AdminControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @admin = admin(:fuga)
    login_as(@admin, scope: :admin)
  end

  # test "the truth" do
  #   assert true
  # end
end
