FactoryBot.define do
  factory :foo do
    sequence(:name) { |n| "foo#{n}" }
  end
end
