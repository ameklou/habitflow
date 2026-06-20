require "rails_helper"

RSpec.describe "Achievements", type: :request do
  describe "GET /achievements" do
    it "requires authentication" do
      get achievements_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows locked and unlocked achievements" do
      user = create(:user)
      create(:habit, user: user)

      sign_in user
      get achievements_path

      expect(response.body).to include("Achievements")
      expect(response.body).to include("First Habit")
      expect(response.body).to include("Unlocked")
      expect(response.body).to include("Locked")
    end
  end
end
