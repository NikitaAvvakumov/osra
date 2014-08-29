FactoryGirl.define do
  factory :partner do
    sequence(:name) { |n| "Name #{n}" }
    province Province.first
  end
end
