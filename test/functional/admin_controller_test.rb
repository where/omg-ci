require 'test_helper'

class AdminTestController < AdminController
  def hello
    render :text => 'world'
  end
end

class AdminControllerTest < ActionController::TestCase
  setup :setup_bogus_controller_routes!
  teardown :teardown_bogus_controller_routes!
  self.controller_class = AdminTestController

  test "controller requires user logged in" do
    user = FactoryGirl.create(:user, :role => 'user')

    get :hello
    assert_redirected_to new_user_session_path

    sign_in user
    get :hello
    assert_response :unauthorized
  end

  test "controller does not allow unroled" do
    unroled = FactoryGirl.create(:user, :role => nil)
    sign_in unroled

    get :hello
    assert_response :unauthorized
  end

  test "controller does allow admins" do
    admin = FactoryGirl.create(:user, :role => 'admin')

    sign_in admin
    get :hello
    assert_response :success
  end
end
