class StatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @habits = current_user.habits.includes(:habit_completions).order(:name)
    @summary = Habits::ProgressSummary.new(habits: @habits)
    @last_7_days = @summary.last_7_days
    @last_30_days = @summary.last_30_days
  end
end
