require "rails_helper"

RSpec.describe Achievement, type: :model do
  subject(:achievement) { build(:achievement) }

  it { is_expected.to be_valid }
  it { is_expected.to have_many(:user_achievements).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:user_achievements) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_presence_of(:condition_type) }
  it { is_expected.to validate_numericality_of(:condition_value).only_integer.is_greater_than(0) }

  it "requires a supported condition type" do
    achievement.condition_type = "unknown"

    expect(achievement).not_to be_valid
    expect(achievement.errors[:condition_type]).to be_present
  end
end
