module Habits
  class UndoCompletion
    def self.call(...)
      new(...).call
    end

    def initialize(habit:, completed_on: Time.zone.today)
      @habit = habit
      @completed_on = completed_on
    end

    def call
      habit.habit_completions.find_by(completed_on: completed_on)&.destroy
    end

    private

    attr_reader :habit, :completed_on
  end
end
