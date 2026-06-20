class HabitCompletion < ApplicationRecord
  belongs_to :habit
  has_one :user, through: :habit

  validates :completed_on, presence: true, uniqueness: { scope: :habit_id }
  validates :count, numericality: { only_integer: true, greater_than: 0 }
end
