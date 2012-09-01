require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should_not allow_value(nil).for(:role)    
  should allow_value("admin").for(:role)
  should allow_value("user").for(:role)
  should_not allow_value("omg").for(:role)

  test "user?" do
    user = FactoryGirl.create(:user, :role => 'user')
    assert user.user?
    assert ! user.admin?
  end

  test "admin?" do
    user = FactoryGirl.create(:user, :role => 'admin')
    assert user.admin?
    assert !user.user?
  end
end

