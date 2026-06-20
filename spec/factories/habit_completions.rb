FactoryBot.define do
  factory :habit_completion do
    habit
    completed_on { Date.current }
    note { "Felt good today." }
    count { 1 }
  end
end
