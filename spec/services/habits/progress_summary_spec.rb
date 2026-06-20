require "rails_helper"

RSpec.describe Habits::ProgressSummary do
  let(:end_date) { Date.new(2026, 6, 12) }
  let(:user) { create(:user) }

  it "summarizes today's completed and remaining habits" do
    completed_habit = create(:habit, user: user, created_at: end_date - 2)
    remaining_habit = create(:habit, user: user, created_at: end_date - 2)
    create(:habit_completion, habit: completed_habit, completed_on: end_date)

    summary = described_class.new(habits: user.habits.includes(:habit_completions), end_date: end_date).today

    expect(summary.total).to eq(2)
    expect(summary.completed).to eq(1)
    expect(summary.remaining).to eq(1)
    expect(summary.completion_rate).to eq(50)
  end

  it "only counts custom-day habits on matching weekdays" do
    create(:habit, :custom_days, user: user, days_of_week: [ end_date.wday ], created_at: end_date - 2)
    create(:habit, :custom_days, user: user, days_of_week: [ (end_date.wday + 1) % 7 ], created_at: end_date - 2)

    summary = described_class.new(habits: user.habits, end_date: end_date).today

    expect(summary.total).to eq(1)
  end

  it "calculates the current streak through the end date" do
    habit = create(:habit, user: user, created_at: end_date - 4)
    create(:habit_completion, habit: habit, completed_on: end_date)
    create(:habit_completion, habit: habit, completed_on: end_date - 1)
    create(:habit_completion, habit: habit, completed_on: end_date - 2)

    summary = described_class.new(habits: user.habits.includes(:habit_completions), end_date: end_date)

    expect(summary.current_streak).to eq(3)
  end

  it "calculates the longest streak" do
    habit = create(:habit, user: user, created_at: end_date - 6)
    create(:habit_completion, habit: habit, completed_on: end_date - 6)
    create(:habit_completion, habit: habit, completed_on: end_date - 5)
    create(:habit_completion, habit: habit, completed_on: end_date - 3)
    create(:habit_completion, habit: habit, completed_on: end_date - 2)
    create(:habit_completion, habit: habit, completed_on: end_date - 1)

    summary = described_class.new(habits: user.habits.includes(:habit_completions), end_date: end_date)

    expect(summary.longest_streak).to eq(3)
  end

  it "calculates completion rate for a date window" do
    habit = create(:habit, user: user, created_at: end_date - 6)
    create(:habit_completion, habit: habit, completed_on: end_date)
    create(:habit_completion, habit: habit, completed_on: end_date - 1)
    create(:habit_completion, habit: habit, completed_on: end_date - 2)
    create(:habit_completion, habit: habit, completed_on: end_date - 3)

    summary = described_class.new(habits: user.habits.includes(:habit_completions), end_date: end_date)

    expect(summary.completion_rate(7)).to eq(57)
  end
end
