require "rails_helper"

RSpec.describe CategoryPolicy do
  subject(:policy) { described_class.new(user, category) }

  let(:user) { create(:user) }

  context "when the category belongs to the user" do
    let(:category) { create(:category, user: user) }

    it "permits management" do
      expect(policy).to be_show
      expect(policy).to be_update
      expect(policy).to be_destroy
    end
  end

  context "when the category belongs to another user" do
    let(:category) { create(:category) }

    it "forbids management" do
      expect(policy).not_to be_show
      expect(policy).not_to be_update
      expect(policy).not_to be_destroy
    end
  end

  describe "scope" do
    it "returns only the user's categories" do
      owned_category = create(:category, user: user)
      create(:category)

      resolved = described_class::Scope.new(user, Category.all).resolve

      expect(resolved).to contain_exactly(owned_category)
    end
  end
end
