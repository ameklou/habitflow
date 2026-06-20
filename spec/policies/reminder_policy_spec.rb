require "rails_helper"

RSpec.describe ReminderPolicy do
  subject(:policy) { described_class.new(user, reminder) }

  let(:user) { create(:user) }

  context "when the reminder belongs to the user's habit" do
    let(:reminder) { create(:reminder, habit: create(:habit, user: user)) }

    it "permits management" do
      expect(policy).to be_show
      expect(policy).to be_update
      expect(policy).to be_destroy
    end
  end

  context "when the reminder belongs to another user's habit" do
    let(:reminder) { create(:reminder) }

    it "forbids management" do
      expect(policy).not_to be_show
      expect(policy).not_to be_update
      expect(policy).not_to be_destroy
    end
  end

  describe "scope" do
    it "returns only reminders for the user's habits" do
      owned_reminder = create(:reminder, habit: create(:habit, user: user))
      create(:reminder)

      resolved = described_class::Scope.new(user, Reminder.all).resolve

      expect(resolved).to contain_exactly(owned_reminder)
    end
  end
end
