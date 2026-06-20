require "rails_helper"

RSpec.describe "Habits", type: :request do
  let(:user) { create(:user) }

  describe "GET /habits" do
    it "requires authentication" do
      get habits_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "lists only the current user's habits" do
      create(:habit, user: user, name: "Drink water")
      create(:habit, name: "Private habit")

      sign_in user
      get habits_path

      expect(response.body).to include("Drink water")
      expect(response.body).not_to include("Private habit")
    end
  end

  describe "GET /habits/:id" do
    it "does not expose another user's habit" do
      other_habit = create(:habit)

      sign_in user
      get habit_path(other_habit)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /habits" do
    it "creates a habit for the current user" do
      category = create(:category, user: user, name: "Learning")
      sign_in user

      expect do
        post habits_path, params: {
          habit: {
            name: "Read",
            description: "Read before bed",
            frequency: "daily",
            category_id: category.id,
            goal_count: 1,
            color: "#059669",
            icon: "book",
            reminder_time: "21:00",
            active: "1"
          }
        }
      end.to change(user.habits, :count).by(1)

      expect(response).to redirect_to(habit_path(Habit.last))
      expect(Habit.last.name).to eq("Read")
      expect(Habit.last.category).to eq(category)
    end

    it "does not assign another user's category" do
      other_category = create(:category)
      sign_in user

      post habits_path, params: {
        habit: {
          name: "Read",
          frequency: "daily",
          category_id: other_category.id,
          goal_count: 1
        }
      }

      expect(Habit.last.category).to be_nil
    end

    it "renders validation errors" do
      sign_in user

      post habits_path, params: { habit: { name: "", frequency: "daily", goal_count: 1 } }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Name can")
      expect(response.body).to include("be blank")
    end
  end

  describe "PATCH /habits/:id" do
    it "updates the current user's habit" do
      habit = create(:habit, user: user, name: "Read")
      category = create(:category, user: user, name: "Learning")
      sign_in user

      patch habit_path(habit), params: { habit: { name: "Read daily", frequency: "weekly", category_id: category.id, goal_count: 2 } }

      expect(response).to redirect_to(habit_path(habit))
      expect(habit.reload.name).to eq("Read daily")
      expect(habit.frequency).to eq("weekly")
      expect(habit.category).to eq(category)
    end
  end

  describe "PATCH /habits/:id/archive" do
    it "archives the current user's habit" do
      habit = create(:habit, user: user)
      sign_in user

      patch archive_habit_path(habit)

      expect(response).to redirect_to(habits_path)
      expect(habit.reload).to be_archived
      expect(habit).not_to be_active
    end
  end

  describe "DELETE /habits/:id" do
    it "deletes the current user's habit" do
      habit = create(:habit, user: user)
      sign_in user

      expect do
        delete habit_path(habit)
      end.to change(user.habits, :count).by(-1)

      expect(response).to redirect_to(habits_path)
    end
  end
end
