require 'test_helper'

class SuiteRunTest < ActiveSupport::TestCase
  should belong_to :suite
  should allow_value('success').for(:status)
  should allow_value('running').for(:status)
  should allow_value('failed').for(:status)
  should_not allow_value(nil).for(:status)
  should_not allow_value("omg").for(:status)
end
