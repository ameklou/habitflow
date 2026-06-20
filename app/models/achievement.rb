class Achievement < ApplicationRecord
  CONDITION_TYPES = {
    "Habit count" => "habit_count",
    "Completion count" => "completion_count",
    "Current streak" => "current_streak"
  }.freeze

  has_many :user_achievements, dependent: :destroy
  has_many :users, through: :user_achievements

  validates :name, :description, :key, :condition_type, presence: true
  validates :key, uniqueness: true
  validates :condition_type, inclusion: { in: CONDITION_TYPES.values }
  validates :condition_value, numericality: { only_integer: true, greater_than: 0 }
end
