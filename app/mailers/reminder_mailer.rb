class ReminderMailer < ApplicationMailer
  def habit_reminder(reminder)
    @reminder = reminder
    @habit = reminder.habit
    @user = @habit.user

    mail(to: @user.email, subject: "HabitFlow reminder: #{@habit.name}")
  end
end
