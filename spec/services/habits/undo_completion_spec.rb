require "rails_helper"

RSpec.describe Habits::UndoCompletion do
  it "removes the completion for the habit and date" do
    completion = create(:habit_completion, completed_on: Date.current)

    expect do
      described_class.call(habit: completion.habit, completed_on: Date.current)
    end.to change(HabitCompletion, :count).by(-1)
  end

  it "does nothing when no completion exists for the date" do
    habit = create(:habit)

    expect do
      described_class.call(habit: habit, completed_on: Date.current)
    end.not_to change(HabitCompletion, :count)
  end
end
