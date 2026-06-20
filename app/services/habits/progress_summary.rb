require "set"

module Habits
  class ProgressSummary
    SummaryDay = Data.define(:date, :total, :completed) do
      def remaining
        total - completed
      end

      def completion_rate
        return 0 if total.zero?

        ((completed.to_f / total) * 100).round
      end

      def complete?
        total.positive? && completed >= total
      end
    end

    def initialize(habits:, end_date: Time.zone.today)
      @habits = Array(habits)
      @end_date = end_date
    end

    def today
      summary_for(end_date)
    end

    def due_habits(date = end_date)
      habits.select { |habit| due_on?(habit, date) }
    end

    def last_7_days
      range_summary((end_date - 6)..end_date)
    end

    def last_30_days
      range_summary((end_date - 29)..end_date)
    end

    def current_streak
      streak = 0
      date = end_date

      loop do
        day = summary_for(date)
        break unless day.complete?

        streak += 1
        date -= 1
      end

      streak
    end

    def longest_streak
      days = range_summary(first_habit_date..end_date)
      longest = 0
      current = 0

      days.each do |day|
        if day.complete?
          current += 1
          longest = [ longest, current ].max
        else
          current = 0
        end
      end

      longest
    end

    def completion_rate(days)
      summaries = range_summary((end_date - (days - 1))..end_date)
      total = summaries.sum(&:total)
      completed = summaries.sum(&:completed)
      return 0 if total.zero?

      ((completed.to_f / total) * 100).round
    end

    def total_completions
      completion_counts.values.sum
    end

    private

    attr_reader :habits, :end_date

    def range_summary(range)
      range.map { |date| summary_for(date) }
    end

    def summary_for(date)
      due_habits = habits.select { |habit| due_on?(habit, date) }
      completed = due_habits.count { |habit| completion_dates_by_habit.fetch(habit.id, []).include?(date) }

      SummaryDay.new(date: date, total: due_habits.size, completed: completed)
    end

    def due_on?(habit, date)
      return false if habit.created_at.present? && habit.created_at.to_date > date
      return false if habit.archived? && habit.archived_at.to_date <= date
      return false unless habit.active?

      return habit.days_of_week.include?(date.wday) if habit.custom_days?

      true
    end

    def completion_dates_by_habit
      @completion_dates_by_habit ||= habits.to_h do |habit|
        [ habit.id, habit.habit_completions.map(&:completed_on).to_set ]
      end
    end

    def completion_counts
      @completion_counts ||= habits.to_h do |habit|
        [ habit.id, habit.habit_completions.size ]
      end
    end

    def first_habit_date
      [ habits.filter_map { |habit| habit.created_at&.to_date }.min, end_date ].compact.min || end_date
    end
  end
end
