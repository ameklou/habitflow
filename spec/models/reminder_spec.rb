require "rails_helper"

RSpec.describe Reminder, type: :model do
  subject(:reminder) { build(:reminder) }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to(:habit) }
  it { is_expected.to have_one(:user).through(:habit) }
  it { is_expected.to validate_presence_of(:reminder_time) }

  it "is due when enabled, time matches, and no weekdays are restricted" do
    reminder = build(:reminder, reminder_time: "08:30", days_of_week: [])

    expect(reminder).to be_due_at(Time.zone.parse("2026-06-12 08:30"))
  end

  it "is due only on configured weekdays" do
    time = Time.zone.parse("2026-06-12 08:30")
    reminder = build(:reminder, reminder_time: "08:30", days_of_week: [ time.wday ])

    expect(reminder).to be_due_at(time)
    expect(reminder).not_to be_due_at(time + 1.day)
  end

  it "rejects invalid weekdays" do
    reminder.days_of_week = [ 8 ]

    expect(reminder).not_to be_valid
    expect(reminder.errors[:days_of_week]).to include("contains invalid days")
  end
end
