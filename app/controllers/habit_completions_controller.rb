class HabitCompletionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit

  def create
    authorize @habit, :complete?
    @completion = Habits::CompleteHabit.call(
      habit: @habit,
      completed_on: completion_date,
      note: completion_params[:note]
    )
    Achievements::UnlockAchievement.call(user: current_user)
    prepare_habits_summary

    respond_to do |format|
      format.html { redirect_back_or_to habits_path, notice: "Habit completed." }
      format.turbo_stream
    end
  end

  def destroy
    authorize @habit, :undo_completion?
    Habits::UndoCompletion.call(habit: @habit, completed_on: completion_date)
    prepare_habits_summary

    respond_to do |format|
      format.html { redirect_back_or_to habits_path, notice: "Completion undone." }
      format.turbo_stream
    end
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:habit_id])
  end

  def completion_params
    params.fetch(:habit_completion, {}).permit(:note)
  end

  def completion_date
    Time.zone.today
  end

  def prepare_habits_summary
    habits = policy_scope(current_user.habits).includes(:category, :habit_completions)
    @habits = Habits::ProgressSummary.new(habits: habits).due_habits
  end
end
