module Habits
  class CompleteHabit
    def self.call(...)
      new(...).call
    end

    def initialize(habit:, completed_on: Time.zone.today, note: nil, count: 1)
      @habit = habit
      @completed_on = completed_on
      @note = note
      @count = count.presence || 1
    end

    def call
      completion = habit.habit_completions.find_or_initialize_by(completed_on: completed_on)
      completion.note = note if note.present?
      completion.count = count
      completion.save!
      completion
    end

    private

    attr_reader :habit, :completed_on, :note, :count
  end
end
