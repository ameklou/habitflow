FactoryBot.define do
  factory :user do
    sequence(:email) { |number| "user#{number}@example.com" }
    password { "password123" }
    name { "Habit Tracker" }
    timezone { "UTC" }
  end
end
