require "rails_helper"

RSpec.describe Habit, type: :model do
  subject(:habit) { build(:habit) }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(120) }
  it { is_expected.to validate_presence_of(:frequency) }
  it { is_expected.to validate_numericality_of(:goal_count).only_integer.is_greater_than(0) }

  it "requires a valid hex color when color is present" do
    habit.color = "green"

    expect(habit).not_to be_valid
    expect(habit.errors[:color]).to be_present
  end

  it "requires custom days to include at least one day" do
    habit.frequency = "custom_days"
    habit.days_of_week = []

    expect(habit).not_to be_valid
    expect(habit.errors[:days_of_week]).to include("must include at least one day")
  end

  it "rejects invalid day numbers" do
    habit.days_of_week = [ 1, 8 ]

    expect(habit).not_to be_valid
    expect(habit.errors[:days_of_week]).to include("contains invalid days")
  end

  it "requires the category to belong to the same user" do
    habit.category = create(:category)

    expect(habit).not_to be_valid
    expect(habit.errors[:category]).to include("must belong to the same user")
  end

  it "archives the habit" do
    habit = create(:habit)

    habit.archive!

    expect(habit).to be_archived
    expect(habit).not_to be_active
  end
end
