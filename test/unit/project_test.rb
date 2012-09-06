require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should allow_value("omg").for(:name)
  should_not allow_value(nil).for(:name)

  should allow_value("git://git.git").for(:git_repo)
  should_not allow_value(nil).for(:git_repo)
  should have_many :suites

  test "before create clones" do
    Git.expects(:clone).once
    Project.create(:name => 'omg', :git_repo => 'git://omg.omg')
  end

  test "before destroy remove the repo" do
    proj = FactoryGirl.create(:project, :name => 'omg')
    FileUtils.expects(:rm_rf).with(Stage.dir('omg')).at_least(1)
    proj.destroy 
  end


  test "destroying a project removes all suites associated with it" do
    proj = FactoryGirl.create(:project)
    suite1 = FactoryGirl.create(:suite, :project => proj)
    suite2 = FactoryGirl.create(:suite)

    assert_difference ['Project.count', 'Suite.count'], -1 do
      proj.destroy
    end
  end

  test "omg_pull_requests" do
    proj1 = FactoryGirl.create(:project, :omg_pull_request => true)
    proj2 = FactoryGirl.create(:project, :omg_pull_request => false)

    assert_equal [proj1], Project.omg_pull_request
  end
end
