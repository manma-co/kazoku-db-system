require 'test_helper'

class Admin::NewsLetterControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_news_letter_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_news_letter_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_news_letter_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_news_letter_edit_url
    assert_response :success
  end

end
