require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should allow_value("omg").for(:name)
  should_not allow_value(nil).for(:name)

  should allow_value("git://git.git").for(:git_repo)
  should_not allow_value(nil).for(:git_repo)
end
