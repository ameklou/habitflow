require "rails_helper"

RSpec.describe "Reminders and achievements", type: :system do
  before do
    driven_by :rack_test
  end

  it "lets a user manage reminders and view achievements" do
    user = create(:user, password: "password123")
    create(:habit, user: user, name: "Read")

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    click_link "Reminders"
    click_link "New reminder"

    select "Read", from: "Habit"
    fill_in "Reminder time", with: "08:30"
    check "Monday"
    click_button "Create Reminder"

    expect(page).to have_content("Reminder created.")
    expect(page).to have_content("Read")
    expect(page).to have_content("08:30")

    click_link "Edit"
    fill_in "Reminder time", with: "09:15"
    click_button "Update Reminder"

    expect(page).to have_content("Reminder updated.")
    expect(page).to have_content("09:15")

    click_link "Achievements"

    expect(page).to have_content("Achievements")
    expect(page).to have_content("First Habit")
    expect(page).to have_content("Unlocked")
  end
end
