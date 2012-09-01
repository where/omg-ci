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

  test "edit success" do
    user = FactoryGirl.create(:user, :role => 'admin')
    sign_in user

    other_guy = FactoryGirl.create(:user)

    get :edit, :id => other_guy.id
    assert_response :success
  end

  test "edit myself fails" do
    user = FactoryGirl.create(:user, :role => 'admin')
    sign_in user

    get :edit, :id => user.id
    assert_response :bad_request
  end

  test "edit not found" do
    user = FactoryGirl.create(:user, :role => 'admin')
    sign_in user

    get :edit, :id => 'omg'
    assert_response :not_found
  end

end
