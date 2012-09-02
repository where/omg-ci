require 'test_helper'

class SuiteTest < ActiveSupport::TestCase
  should belong_to :project
  should allow_value("omg").for(:name)
  should_not allow_value(nil).for(:name)

  should allow_value("Rails").for(:suite_type)
  should allow_value("Ruby").for(:suite_type)
  should_not allow_value("omg").for(:suite_type)
  should_not allow_value(nil).for(:suite_type)

  should_not allow_value(nil).for(:project)

  should_not allow_value(nil).for(:command)
  should allow_value("echo omg").for(:command)

  should_not allow_value(nil).for(:branch)
  should allow_value("master").for(:branch)

  test "execute!" do
    suite = FactoryGirl.create(:suite)
    suite.expects(:run).once.returns({:success =>true, :result => 'omg stuff'})
 
    suite.execute!
  end

  test "needs_to_run?" do
    Rails.cache.clear
    suite = FactoryGirl.create(:suite)
    assert suite.needs_to_run?

    suite.execute!
    assert ! suite.needs_to_run?

    Rails.cache.delete(suite.cache_key)
    assert suite.needs_to_run?
  end

end
