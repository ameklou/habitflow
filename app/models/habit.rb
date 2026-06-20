class Habit < ApplicationRecord
  DAYS_OF_WEEK = {
    "Sunday" => 0,
    "Monday" => 1,
    "Tuesday" => 2,
    "Wednesday" => 3,
    "Thursday" => 4,
    "Friday" => 5,
    "Saturday" => 6
  }.freeze

  belongs_to :user
  belongs_to :category, optional: true
  has_many :habit_completions, dependent: :destroy
  has_many :reminders, dependent: :destroy

  enum :frequency, { daily: "daily", weekly: "weekly", custom_days: "custom_days" }, default: "daily"

  scope :unarchived, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }
  scope :active, -> { where(active: true) }

  validates :name, presence: true, length: { maximum: 120 }
  validates :frequency, presence: true
  validates :goal_count, numericality: { only_integer: true, greater_than: 0 }
  validates :color, format: { with: /\A#[0-9a-fA-F]{6}\z/ }, allow_blank: true
  validate :category_belongs_to_user
  validate :days_of_week_are_valid
  validate :custom_days_include_at_least_one_day

  def archived?
    archived_at.present?
  end

  def archive!
    update!(active: false, archived_at: Time.current)
  end

  def completed_on?(date)
    habit_completions.exists?(completed_on: date)
  end

  def completion_on(date)
    habit_completions.find_by(completed_on: date)
  end

  private

  def days_of_week_are_valid
    invalid_days = days_of_week.reject { |day| DAYS_OF_WEEK.value?(day) }
    errors.add(:days_of_week, "contains invalid days") if invalid_days.any?
  end

  def custom_days_include_at_least_one_day
    return unless custom_days?

    errors.add(:days_of_week, "must include at least one day") if days_of_week.blank?
  end

  def category_belongs_to_user
    return if category_id.blank? || category&.user_id == user_id

    errors.add(:category, "must belong to the same user")
  end
end
