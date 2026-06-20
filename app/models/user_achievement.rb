class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  before_validation :set_unlocked_at, on: :create

  validates :achievement_id, uniqueness: { scope: :user_id }
  validates :unlocked_at, presence: true

  private

  def set_unlocked_at
    self.unlocked_at ||= Time.current
  end
end
