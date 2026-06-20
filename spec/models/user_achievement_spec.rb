require "rails_helper"

RSpec.describe UserAchievement, type: :model do
  subject(:user_achievement) { build(:user_achievement) }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:achievement) }

  it "sets unlocked_at on create" do
    user_achievement = create(:user_achievement, unlocked_at: nil)

    expect(user_achievement.unlocked_at).to be_present
  end

  it "allows one unlock per user and achievement" do
    existing_unlock = create(:user_achievement)
    duplicate_unlock = build(
      :user_achievement,
      user: existing_unlock.user,
      achievement: existing_unlock.achievement
    )

    expect(duplicate_unlock).not_to be_valid
    expect(duplicate_unlock.errors[:achievement_id]).to include("has already been taken")
  end
end
