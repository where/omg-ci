require 'test_helper'

class SuiteTest < ActiveSupport::TestCase
  should belong_to :project
  should have_many :suite_runs
  should allow_value("omg").for(:name)
  should_not allow_value(nil).for(:name)

  should_not allow_value(nil).for(:project)

  should_not allow_value(nil).for(:command)
  should allow_value("echo omg").for(:command)

  should_not allow_value(nil).for(:branch)
  should allow_value("master").for(:branch)

  should allow_value("commit").for(:trigger)
  should allow_value("time").for(:trigger)
  should_not allow_value(nil).for(:trigger)
  should_not allow_value('omg').for(:trigger)

  should_not allow_value(-1).for(:trigger_length)
  should_not allow_value(0).for(:trigger_length)
  should_not allow_value('omg').for(:trigger_length)

  should_not allow_value("omg").for(:trigger_metric)
  should allow_value("minutes").for(:trigger_metric)
  should allow_value("hours").for(:trigger_metric)


  test "execute!" do
    suite = FactoryGirl.create(:suite)
    suite.expects(:run_suite).once.returns({:success =>true, :result => 'omg stuff'})
 
    assert_difference 'suite.suite_runs.count' do
      suite.execute!
    end

    run = SuiteRun.last
    assert_equal suite.current_sha, run.sha
    assert run.result.include?(run.sha)
    assert run.result.include?("omg stuff")
    assert run.success?
  end

  test "needs_to_run?" do
    Rails.cache.clear
    suite = FactoryGirl.create(:suite, :trigger => 'commit')
    assert suite.needs_to_run?

    suite.execute!
    assert ! suite.needs_to_run?

    Rails.cache.delete(suite.cache_key)
    assert suite.needs_to_run?

    Rails.cache.clear
    suite = FactoryGirl.create(:suite, :trigger => 'time', :trigger_length => 2, :trigger_metric => 'minutes')

    assert suite.needs_to_run?

    suite.execute!
    assert ! suite.needs_to_run?

    Timecop.freeze(Time.now + 10.minutes) do
      assert suite.needs_to_run?
    end
  end

  test "validate if time trigger needs trigger_length and trigger_metric" do
    suite = FactoryGirl.build(:suite, :trigger => 'time',
      :trigger_length => nil, :trigger_metric => nil)

    assert suite.invalid?

    suite.trigger_length = 10
    suite.trigger_metric = 'hours'
    assert suite.valid?

    suite.trigger_length = nil
    assert suite.invalid?
    assert ! suite.errors[:trigger_length].blank?

    suite.trigger_length = 10
    suite.trigger_metric = nil
    assert suite.invalid?
    assert ! suite.errors[:trigger_metric].blank?
  end

  test "trigger time" do
    assert_nil Suite.new.trigger_delta
    suite = Suite.new(:trigger_length => 2, :trigger_metric => 'minutes')
    assert_equal 2.minutes, suite.trigger_delta

    suite = Suite.new(:trigger_length => 2, :trigger_metric => 'hours')
    assert_equal 2.hours, suite.trigger_delta
  end

  test "destorying a suite should remove all suite_runs" do
    suite = FactoryGirl.create(:suite)
    suite_run1 = FactoryGirl.create(:suite_run, :suite => suite)
    suite_run2 = FactoryGirl.create(:suite_run)

    assert_difference ['Suite.count', 'SuiteRun.count'], -1 do
      suite.destroy
    end
  end

end
