require 'test_helper'

class NotificationTest < ActionMailer::TestCase
  test "failure message" do
    suite = FactoryGirl.create(:suite, :email_notification => 'omg@omg.com,hello@omg.com')
    suite_run = FactoryGirl.create(:suite_run, :suite => suite)
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      Notification.failure_message(suite_run).deliver
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["omg@omg.com", "hello@omg.com"], mail.to
  end
end
