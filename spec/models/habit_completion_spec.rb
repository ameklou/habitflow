require "rails_helper"

RSpec.describe HabitCompletion, type: :model do
  subject(:completion) { build(:habit_completion) }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to(:habit) }
  it { is_expected.to have_one(:user).through(:habit) }
  it { is_expected.to validate_presence_of(:completed_on) }
  it { is_expected.to validate_numericality_of(:count).only_integer.is_greater_than(0) }

  it "allows only one completion per habit per day" do
    existing_completion = create(:habit_completion)
    completion = build(
      :habit_completion,
      habit: existing_completion.habit,
      completed_on: existing_completion.completed_on
    )

    expect(completion).not_to be_valid
    expect(completion.errors[:completed_on]).to include("has already been taken")
  end
end
