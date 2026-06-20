require "rails_helper"

RSpec.describe "Habit completions", type: :request do
  let(:user) { create(:user) }
  let(:habit) { create(:habit, user: user) }

  describe "POST /habits/:habit_id/completion" do
    it "requires authentication" do
      post habit_completion_path(habit)

      expect(response).to redirect_to(new_user_session_path)
    end

    it "completes the habit for today with an optional note" do
      sign_in user

      expect do
        post habit_completion_path(habit), params: { habit_completion: { note: "Strong start" } }
      end.to change(habit.habit_completions, :count).by(1)

      expect(response).to redirect_to(habits_path)
      expect(habit.completion_on(Time.zone.today).note).to eq("Strong start")
    end

    it "does not expose another user's habit" do
      other_habit = create(:habit)
      sign_in user

      post habit_completion_path(other_habit)

      expect(response).to have_http_status(:not_found)
    end

    it "does not complete archived habits" do
      archived_habit = create(:habit, :archived, user: user)
      sign_in user

      post habit_completion_path(archived_habit)

      expect(response).to redirect_to(root_path)
      expect(archived_habit.habit_completions).to be_empty
    end

    it "renders a turbo stream update" do
      sign_in user

      post habit_completion_path(habit), params: { habit_completion: { note: "Done" } }, as: :turbo_stream

      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("habits_completion_summary")
      expect(response.body).to include("Completed")
      expect(response.body).to include("Done")
    end
  end

  describe "DELETE /habits/:habit_id/completion" do
    it "undoes today's completion" do
      create(:habit_completion, habit: habit, completed_on: Time.zone.today)
      sign_in user

      expect do
        delete habit_completion_path(habit)
      end.to change(habit.habit_completions, :count).by(-1)

      expect(response).to redirect_to(habits_path)
    end

    it "renders a turbo stream update" do
      create(:habit_completion, habit: habit, completed_on: Time.zone.today)
      sign_in user

      delete habit_completion_path(habit), as: :turbo_stream

      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("habits_completion_summary")
      expect(response.body).to include("Complete today")
    end
  end
end
