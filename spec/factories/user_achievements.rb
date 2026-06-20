FactoryBot.define do
  factory :user_achievement do
    user
    achievement
    unlocked_at { Time.current }
  end
end
