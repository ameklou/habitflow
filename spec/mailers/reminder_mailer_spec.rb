require "rails_helper"

RSpec.describe ReminderMailer, type: :mailer do
  describe "#habit_reminder" do
    it "sends a habit reminder email" do
      user = create(:user, email: "person@example.com")
      habit = create(:habit, user: user, name: "Drink water")
      reminder = create(:reminder, habit: habit)

      mail = described_class.habit_reminder(reminder)

      expect(mail.to).to eq([ "person@example.com" ])
      expect(mail.subject).to eq("HabitFlow reminder: Drink water")
      expect(mail.body.encoded).to include("Drink water")
    end
  end
end
