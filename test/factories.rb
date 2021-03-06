FactoryGirl.define do
  factory :project do
    name "omg"
    git_repo "git://omg.git"
  end

  factory :user do
    sequence(:email) {|n| "user#{n}@omgmail.com"}
    password "lollol"
    password_confirmation "lollol"
    role "user"
  end

  factory :suite do
    name "omg"
    association :project
    command "echo omg"
    email_notification "tenderooni@mj.com"
    branch "master"
    trigger 'commit'
  end

  factory :suite_run do
    association :suite
    status "success"
    sha "omg"
  end
end
