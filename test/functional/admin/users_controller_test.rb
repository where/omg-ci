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

  test "update success" do
    user = FactoryGirl.create(:user, :role => 'admin')
    sign_in user
    other_guy = FactoryGirl.create(:user, :role => nil)

    put :update, :id => other_guy.id, :user => {:role => 'admin'}
    assert_redirected_to admin_users_path

    other_guy.reload
    assert_equal 'admin', other_guy.role
  end

  test "update not found" do
    user = FactoryGirl.create(:user, :role => 'admin')
    sign_in user
    put :update, :id => 'omg'
    assert_response :not_found
  end

  test "update self" do
    user = FactoryGirl.create(:user, :role => 'admin')
    sign_in user
    put :update, :id => user.id, :user => {:role => nil}
      assert_response :bad_request
  end

  test "update invalid" do
    user = FactoryGirl.create(:user, :role => 'admin')
    sign_in user
    other_guy = FactoryGirl.create(:user)
    put :update, :id => other_guy.id, :user => {:role => 'omg'}
    assert_response :unprocessable_entity
    assert_template :edit
  end

end
