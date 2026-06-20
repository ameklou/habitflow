module Achievements
  class UnlockAchievement
    DEFAULT_ACHIEVEMENTS = [
      {
        key: "first_habit",
        name: "First Habit",
        description: "Create your first habit.",
        icon: "plus",
        condition_type: "habit_count",
        condition_value: 1
      },
      {
        key: "first_completion",
        name: "First Completion",
        description: "Complete a habit for the first time.",
        icon: "check",
        condition_type: "completion_count",
        condition_value: 1
      },
      {
        key: "ten_completions",
        name: "Ten Completions",
        description: "Complete habits 10 times.",
        icon: "list-check",
        condition_type: "completion_count",
        condition_value: 10
      },
      {
        key: "seven_day_streak",
        name: "Seven Day Streak",
        description: "Complete all due habits for 7 days in a row.",
        icon: "flame",
        condition_type: "current_streak",
        condition_value: 7
      }
    ].freeze

    def self.call(user:)
      new(user: user).call
    end

    def self.ensure_defaults!
      DEFAULT_ACHIEVEMENTS.each do |attributes|
        Achievement.find_or_create_by!(key: attributes[:key]) do |achievement|
          achievement.assign_attributes(attributes)
        end
      end
    end

    def initialize(user:)
      @user = user
    end

    def call
      self.class.ensure_defaults!
      Achievement.find_each.filter_map do |achievement|
        unlock(achievement) if earned?(achievement)
      end
    end

    private

    attr_reader :user

    def earned?(achievement)
      case achievement.condition_type
      when "habit_count"
        user.habits.count >= achievement.condition_value
      when "completion_count"
        user.habit_completions.count >= achievement.condition_value
      when "current_streak"
        Habits::ProgressSummary.new(habits: user.habits.includes(:habit_completions)).current_streak >= achievement.condition_value
      else
        false
      end
    end

    def unlock(achievement)
      UserAchievement.find_or_create_by!(user: user, achievement: achievement)
    end
  end
end
