require 'test_helper'

class SuitesControllerTest < ActionController::TestCase
  test "new project not found" do
    user = FactoryGirl.create(:user)
    sign_in user

    get :new, :project_id => 'omg'
    assert_response :not_found
  end

  test "new project success" do
    user = FactoryGirl.create(:user)
    sign_in user
    project = FactoryGirl.create(:project)

    get :new, :project_id => project.id
    assert_response :success
  end

  test "create not found" do
    user = FactoryGirl.create(:user)
    sign_in user
    post :create, :project_id => 'omg'
    assert_response :not_found
  end

  test "create success" do
    user = FactoryGirl.create(:user)
    sign_in user
    project = FactoryGirl.create(:project)
    assert_difference 'project.suites.count' do
      post :create, :project_id => project.id, :suite => {
        :name => 'Regular',
        :command => 'echo hi',
        :branch => 'master',
        :trigger => 'commit'
      }
    end

    assert_redirected_to projects_path

    suite = Suite.last

    assert_equal 'Regular', suite.name
  end

  test "create validation error" do
    user = FactoryGirl.create(:user)
    sign_in user
    project = FactoryGirl.create(:project)
    assert_no_difference 'project.suites.count' do
      post :create, :project_id => project.id, :suite => {
        :name => '',
      }
    end

    assert_response :unprocessable_entity
    assert_template :new
  end

  test "edit success" do
    user = FactoryGirl.create(:user)
    sign_in user
    suite = FactoryGirl.create(:suite)
    get :edit, :id => suite.id
    assert_response :success
  end

  test "edit not found" do
    user = FactoryGirl.create(:user)
    sign_in user
    get :edit, :id => 'omg'
    assert_response :not_found
  end


  test "update success" do
    user = FactoryGirl.create(:user)
    sign_in user
    suite = FactoryGirl.create(:suite, :name => 'omg')
    put :update, :id => suite.id, :suite => {:name => 'lol'}
    assert_redirected_to projects_path
    suite.reload
    assert_equal 'lol', suite.name
  end

  test "update not found" do
    user = FactoryGirl.create(:user)
    sign_in user
    put :update, :id => 'omg'
    assert_response :not_found
  end

  test "update validation error" do
    user = FactoryGirl.create(:user)
    sign_in user
    suite = FactoryGirl.create(:suite)
    put :update, :id => suite.id, :suite => {:name => ''}
    assert_response :unprocessable_entity
    suite.reload
    assert ! suite.name.blank?
  end

  test "destroy" do
    user = FactoryGirl.create(:user)
    sign_in user
    suite = FactoryGirl.create(:suite)
    assert_difference 'Suite.count', -1 do
      delete :destroy, :id => suite.id
    end

    assert_redirected_to projects_path
  end

  test "destroy not found" do
    user = FactoryGirl.create(:user)
    sign_in user
    assert_no_difference 'Suite.count' do
      delete :destroy, :id => 'omg'
    end
  end
end
