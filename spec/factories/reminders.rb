FactoryBot.define do
  factory :reminder do
    habit
    reminder_time { "08:00" }
    days_of_week { [] }
    channel { "email" }
    enabled { true }
  end
end
