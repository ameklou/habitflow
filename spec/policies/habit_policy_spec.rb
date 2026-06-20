require "rails_helper"

RSpec.describe HabitPolicy do
  subject(:policy) { described_class.new(user, habit) }

  let(:user) { create(:user) }

  context "when the habit belongs to the user" do
    let(:habit) { create(:habit, user: user) }

    it "permits management" do
      expect(policy).to be_show
      expect(policy).to be_update
      expect(policy).to be_archive
      expect(policy).to be_complete
      expect(policy).to be_undo_completion
      expect(policy).to be_destroy
    end
  end

  context "when the habit belongs to another user" do
    let(:habit) { create(:habit) }

    it "forbids management" do
      expect(policy).not_to be_show
      expect(policy).not_to be_update
      expect(policy).not_to be_archive
      expect(policy).not_to be_complete
      expect(policy).not_to be_undo_completion
      expect(policy).not_to be_destroy
    end
  end

  context "when the habit is archived" do
    let(:habit) { create(:habit, :archived, user: user) }

    it "forbids completion" do
      expect(policy).not_to be_complete
    end
  end

  describe "scope" do
    it "returns only the user's habits" do
      owned_habit = create(:habit, user: user)
      create(:habit)

      resolved = described_class::Scope.new(user, Habit.all).resolve

      expect(resolved).to contain_exactly(owned_habit)
    end
  end
end
