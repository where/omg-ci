require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should allow_value("omg").for(:name)
  should_not allow_value(nil).for(:name)

  should allow_value("git://git.git").for(:git_repo)
  should_not allow_value(nil).for(:git_repo)

  test "before create clones" do
    Git.expects(:clone).once
    Project.create(:name => 'omg', :git_repo => 'git://omg.omg')
  end

  test "before destroy remove the repo" do
    proj = FactoryGirl.create(:project, :name => 'omg')
    FileUtils.expects(:rm_rf).with(Stage.dir('omg')).at_least(1)
    proj.destroy 
  end
end
