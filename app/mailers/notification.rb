class Notification < ActionMailer::Base
  default from: "no-reply@omg-ci.com"

  def failure_message(suite_run)
    @suite_run = suite_run
    mail(:to => suite_run.suite.email_notification,
         :subject => 'OMG! Failure')
  end

end
