require "rails_helper"

RSpec.describe Habits::CompleteHabit do
  it "creates a completion for the habit and date" do
    habit = create(:habit)

    completion = described_class.call(habit: habit, completed_on: Date.new(2026, 6, 12), note: "Done")

    expect(completion).to be_persisted
    expect(completion.completed_on).to eq(Date.new(2026, 6, 12))
    expect(completion.note).to eq("Done")
  end

  it "is idempotent for the same habit and date" do
    habit = create(:habit)
    completed_on = Date.current

    expect do
      described_class.call(habit: habit, completed_on: completed_on)
      described_class.call(habit: habit, completed_on: completed_on, note: "Updated")
    end.to change(habit.habit_completions, :count).by(1)

    expect(habit.completion_on(completed_on).note).to eq("Updated")
  end
end
