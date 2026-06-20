require "rails_helper"

RSpec.describe "Reminders", type: :request do
  let(:user) { create(:user) }
  let(:habit) { create(:habit, user: user) }

  describe "GET /reminders" do
    it "requires authentication" do
      get reminders_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "lists only reminders for the current user's habits" do
      create(:reminder, habit: habit)
      create(:reminder, habit: create(:habit, name: "Private reminder habit"))

      sign_in user
      get reminders_path

      expect(response.body).to include(habit.name)
      expect(response.body).not_to include("Private reminder habit")
    end
  end

  describe "POST /reminders" do
    it "creates a reminder for the current user's habit" do
      sign_in user

      expect do
        post reminders_path, params: {
          reminder: {
            habit_id: habit.id,
            reminder_time: "08:30",
            channel: "email",
            enabled: "1",
            days_of_week: [ "1", "3" ]
          }
        }
      end.to change(habit.reminders, :count).by(1)

      expect(response).to redirect_to(reminder_path(Reminder.last))
      expect(Reminder.last.days_of_week).to eq([ 1, 3 ])
    end

    it "does not create a reminder for another user's habit" do
      other_habit = create(:habit)
      sign_in user

      post reminders_path, params: {
        reminder: {
          habit_id: other_habit.id,
          reminder_time: "08:30",
          channel: "email",
          enabled: "1"
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(Reminder.count).to eq(0)
    end
  end

  describe "PATCH /reminders/:id" do
    it "updates the current user's reminder" do
      reminder = create(:reminder, habit: habit, reminder_time: "08:00")
      sign_in user

      patch reminder_path(reminder), params: { reminder: { habit_id: habit.id, reminder_time: "09:15", channel: "email", enabled: "0" } }

      expect(response).to redirect_to(reminder_path(reminder))
      expect(reminder.reload.reminder_time.strftime("%H:%M")).to eq("09:15")
      expect(reminder).not_to be_enabled
    end
  end

  describe "DELETE /reminders/:id" do
    it "deletes the current user's reminder" do
      reminder = create(:reminder, habit: habit)
      sign_in user

      expect do
        delete reminder_path(reminder)
      end.to change(habit.reminders, :count).by(-1)

      expect(response).to redirect_to(reminders_path)
    end
  end
end
