require "rails_helper"

RSpec.describe Category, type: :model do
  subject(:category) { build(:category) }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:habits).dependent(:nullify) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(80) }
  it { is_expected.to validate_numericality_of(:position).only_integer.is_greater_than_or_equal_to(0) }

  it "requires names to be unique per user" do
    existing_category = create(:category, name: "Health")
    category = build(:category, user: existing_category.user, name: "Health")

    expect(category).not_to be_valid
    expect(category.errors[:name]).to include("has already been taken")
  end

  it "allows the same name for different users" do
    create(:category, name: "Health")
    category = build(:category, name: "Health")

    expect(category).to be_valid
  end

  it "requires a valid hex color when color is present" do
    category.color = "blue"

    expect(category).not_to be_valid
    expect(category.errors[:color]).to be_present
  end
end
