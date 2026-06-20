require "rails_helper"

RSpec.describe Achievements::UnlockAchievement do
  it "creates default achievement definitions" do
    Achievement.where(key: described_class::DEFAULT_ACHIEVEMENTS.pluck(:key)).delete_all

    expect do
      described_class.ensure_defaults!
    end.to change(Achievement, :count).by(4)

    expect(Achievement.pluck(:key)).to include("first_habit", "first_completion")
  end

  it "unlocks earned habit-count achievements" do
    user = create(:user)
    create(:habit, user: user)

    expect do
      described_class.call(user: user)
    end.to change(user.user_achievements, :count).by(1)

    expect(user.achievements.pluck(:key)).to include("first_habit")
  end

  it "unlocks completion achievements" do
    user = create(:user)
    habit = create(:habit, user: user)
    create(:habit_completion, habit: habit)

    described_class.call(user: user)

    expect(user.achievements.pluck(:key)).to include("first_completion")
  end

  it "is idempotent" do
    user = create(:user)
    create(:habit, user: user)

    described_class.call(user: user)

    expect do
      described_class.call(user: user)
    end.not_to change(user.user_achievements, :count)
  end
end
