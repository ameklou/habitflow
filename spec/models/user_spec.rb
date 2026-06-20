require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_length_of(:name).is_at_most(100) }
  it { is_expected.to validate_presence_of(:timezone) }

  it "defaults to the standard role" do
    expect(described_class.new.role).to eq("standard")
  end
end
