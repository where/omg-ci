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

end
