require 'test_helper'

class SuiteRunsControllerTest < ActionController::TestCase
  test "show not found" do
    user = FactoryGirl.create(:user)
    sign_in user
    get :show, :id => 'omg'
    assert_response :not_found
  end

  test "show found" do
    user = FactoryGirl.create(:user)
    sign_in user
    run = FactoryGirl.create(:suite_run)
    get :show, :id => run.id
    assert_response :success
  end
end
