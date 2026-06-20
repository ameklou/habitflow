class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @habits = current_user.habits.active.unarchived.includes(:category, :habit_completions).order(:name)
    @summary = Habits::ProgressSummary.new(habits: @habits)
    @today = @summary.today
    @todays_habits = @summary.due_habits
    @weekly_summary = @summary.last_7_days
  end
end
