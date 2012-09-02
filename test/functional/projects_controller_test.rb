require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test "index" do
    user = FactoryGirl.create(:user)  
    sign_in user

    get :index

    assert_response :success
  end

  test "new" do
    user = FactoryGirl.create(:user)
    sign_in user

    get :new

    assert_response :success
  end

  test "create" do
    user = FactoryGirl.create(:user)
    sign_in user

    assert_difference 'Project.count' do 
      post :create, :project => {:name => 'omg', :git_repo => 'git://omg.git'}
    end
    assert_redirected_to projects_path
    project = Project.last
    assert_equal 'omg', project.name
    assert_equal 'git://omg.git', project.git_repo
  end

  test "create validation error" do
    user = FactoryGirl.create(:user)
    sign_in user

    assert_no_difference 'Project.count' do
      post :create, :project => {:name => '', :git_repo => nil}
    end

    assert_response :unprocessable_entity
    assert_template :new
  end

  test "destroy success" do
    user = FactoryGirl.create(:user)
    sign_in user

    project = FactoryGirl.create(:project)

    assert_difference 'Project.count', -1 do
      delete :destroy, :id => project.id
    end

    assert_redirected_to projects_path
  end

  test "destroy not found" do
    user = FactoryGirl.create(:user)
    sign_in user

    assert_no_difference 'Project.count' do
      delete :destroy, :id => 'omg'
    end

    assert_response :not_found
  end
end
