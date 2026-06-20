class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: %i[show edit update archive destroy]

  def index
    @habits = policy_scope(current_user.habits).includes(:category, :habit_completions).order(archived_at: :asc, name: :asc)
  end

  def show
    authorize @habit
  end

  def new
    @habit = current_user.habits.build(color: "#059669", goal_count: 1)
    load_categories
    authorize @habit
  end

  def create
    @habit = current_user.habits.build(habit_params)
    authorize @habit

    if @habit.save
      Achievements::UnlockAchievement.call(user: current_user)
      redirect_to @habit, notice: "Habit created."
    else
      load_categories
      render :new, status: :unprocessable_content
    end
  end

  def edit
    load_categories
    authorize @habit
  end

  def update
    authorize @habit

    if @habit.update(habit_params)
      redirect_to @habit, notice: "Habit updated."
    else
      load_categories
      render :edit, status: :unprocessable_content
    end
  end

  def archive
    authorize @habit
    @habit.archive!

    redirect_to habits_path, notice: "Habit archived."
  end

  def destroy
    authorize @habit
    @habit.destroy!

    redirect_to habits_path, notice: "Habit deleted."
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:id])
  end

  def load_categories
    @categories = current_user.categories.order(:position, :name)
  end

  def habit_params
    permitted_params = params.require(:habit).permit(
      :name,
      :category_id,
      :description,
      :color,
      :icon,
      :frequency,
      :goal_count,
      :reminder_time,
      :active,
      days_of_week: []
    )
    permitted_params[:days_of_week] = permitted_params.fetch(:days_of_week, []).reject(&:blank?)
    permitted_params[:category_id] = current_user.categories.find_by(id: permitted_params[:category_id])&.id if permitted_params[:category_id].present?
    permitted_params
  end
end
