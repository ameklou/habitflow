class AchievementsController < ApplicationController
  before_action :authenticate_user!

  def index
    Achievements::UnlockAchievement.call(user: current_user)
    @achievements = Achievement.order(:condition_type, :condition_value, :name)
    @unlocks_by_achievement_id = current_user.user_achievements.index_by(&:achievement_id)
  end
end
