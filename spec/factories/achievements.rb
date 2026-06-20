FactoryBot.define do
  factory :achievement do
    sequence(:name) { |number| "Achievement #{number}" }
    description { "Unlocked by making progress." }
    sequence(:key) { |number| "achievement_#{number}" }
    icon { "star" }
    condition_type { "habit_count" }
    condition_value { 1 }
  end
end
