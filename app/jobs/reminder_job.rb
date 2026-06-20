class ReminderJob < ApplicationJob
  queue_as :default

  def perform(now = Time.current)
    Reminder.enabled.includes(habit: :habit_completions).find_each do |reminder|
      next unless reminder.due_at?(now)
      next unless reminder.habit.active?
      next if reminder.habit.archived?
      next if reminder.habit.completed_on?(now.to_date)

      ReminderMailer.habit_reminder(reminder).deliver_later
    end
  end
end
