require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  test "is_a? AdminController" do
    assert @controller.is_a?(AdminController)
  end

  test "index" do
    user = FactoryGirl.create(:user, :role => 'admin')
    sign_in user

    get :index
    assert_response :success
  end

end
