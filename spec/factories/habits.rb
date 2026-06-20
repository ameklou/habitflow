FactoryBot.define do
  factory :habit do
    user
    sequence(:name) { |number| "Habit #{number}" }
    description { "A steady daily practice." }
    color { "#059669" }
    icon { "check" }
    frequency { "daily" }
    days_of_week { [] }
    goal_count { 1 }
    reminder_time { "08:00" }
    active { true }
    archived_at { nil }

    trait :with_category do
      category { association(:category, user: user) }
    end

    trait :custom_days do
      frequency { "custom_days" }
      days_of_week { [ 1, 3, 5 ] }
    end

    trait :archived do
      active { false }
      archived_at { Time.current }
    end
  end
end
