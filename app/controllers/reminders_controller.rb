class RemindersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reminder, only: %i[show edit update destroy]
  before_action :load_habits, only: %i[new create edit update]

  def index
    @reminders = policy_scope(Reminder).includes(habit: :category).order(:reminder_time)
  end

  def show
    authorize @reminder
  end

  def new
    @reminder = Reminder.new(habit: @habits.first, reminder_time: "08:00", days_of_week: [], enabled: true)
    authorize @reminder
  end

  def create
    @reminder = Reminder.new(reminder_params)
    authorize @reminder

    if @reminder.save
      redirect_to @reminder, notice: "Reminder created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @reminder
  end

  def update
    authorize @reminder

    if @reminder.update(reminder_params)
      redirect_to @reminder, notice: "Reminder updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @reminder
    @reminder.destroy!

    redirect_to reminders_path, notice: "Reminder deleted."
  end

  private

  def set_reminder
    @reminder = policy_scope(Reminder).find(params[:id])
  end

  def load_habits
    @habits = current_user.habits.active.unarchived.order(:name)
  end

  def reminder_params
    permitted_params = params.require(:reminder).permit(
      :habit_id,
      :reminder_time,
      :channel,
      :enabled,
      days_of_week: []
    )
    permitted_params[:habit_id] = current_user.habits.find_by(id: permitted_params[:habit_id])&.id
    permitted_params[:days_of_week] = permitted_params.fetch(:days_of_week, []).reject(&:blank?)
    permitted_params
  end
end
