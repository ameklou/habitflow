class Reminder < ApplicationRecord
  CHANNELS = {
    "Email" => "email"
  }.freeze

  belongs_to :habit
  has_one :user, through: :habit

  enum :channel, { email: "email" }, default: "email"

  scope :enabled, -> { where(enabled: true) }

  validates :reminder_time, presence: true
  validates :channel, presence: true
  validate :days_of_week_are_valid

  def due_at?(time)
    enabled? &&
      reminder_time.hour == time.hour &&
      reminder_time.min == time.min &&
      (days_of_week.blank? || days_of_week.include?(time.to_date.wday))
  end

  private

  def days_of_week_are_valid
    invalid_days = days_of_week.reject { |day| Habit::DAYS_OF_WEEK.value?(day) }
    errors.add(:days_of_week, "contains invalid days") if invalid_days.any?
  end
end
