require "rails_helper"

RSpec.describe "Stats", type: :request do
  describe "GET /stats" do
    it "requires authentication" do
      get stats_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows streaks and completion rates for the current user" do
      user = create(:user)
      habit = create(:habit, user: user, created_at: 2.days.ago)
      create(:habit_completion, habit: habit, completed_on: Time.zone.today)
      create(:habit_completion, habit: habit, completed_on: Time.zone.yesterday)

      sign_in user
      get stats_path

      expect(response.body).to include("Stats")
      expect(response.body).to include("Current streak")
      expect(response.body).to include("Longest streak")
      expect(response.body).to include("7-day rate")
    end
  end
end
