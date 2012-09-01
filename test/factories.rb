FactoryGirl.define do
  factory :project do
    name "omg"
    git_repo "git://omg.git"
  end

  factory :user do
    sequence(:email) {|n| "user#{n}@omgmail.com"}
    password "lollol"
    password_confirmation "lollol"
  end
end
