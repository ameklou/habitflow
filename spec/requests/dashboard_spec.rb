require "rails_helper"

RSpec.describe "Dashboard", type: :request do
  describe "GET /dashboard" do
    it "requires authentication" do
      get dashboard_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows today's scoped habit progress" do
      user = create(:user)
      habit = create(:habit, user: user, name: "Drink water")
      create(:habit_completion, habit: habit, completed_on: Time.zone.today)
      create(:habit, name: "Private habit")

      sign_in user
      get dashboard_path

      expect(response.body).to include("Dashboard")
      expect(response.body).to include("Drink water")
      expect(response.body).to include("Completed")
      expect(response.body).not_to include("Private habit")
    end
  end
end
