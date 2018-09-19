require 'test_helper'

class UploadsPicControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get uploads_pic_new_url
    assert_response :success
  end

  test "should get create" do
    get uploads_pic_create_url
    assert_response :success
  end

  test "should get index" do
    get uploads_pic_index_url
    assert_response :success
  end

end
