require "rails_helper"

RSpec.describe "Habit management", type: :system do
  before do
    driven_by :rack_test
  end

  it "lets a user create, edit, archive, and delete a habit" do
    user = create(:user, password: "password123")

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    click_link "Habits"
    click_link "New habit"

    fill_in "Name", with: "Morning walk"
    fill_in "Description", with: "Walk before starting work"
    select "Daily", from: "Frequency"
    fill_in "Goal count", with: "1"
    fill_in "Icon", with: "footprints"
    fill_in "Reminder time", with: "07:30"
    click_button "Create Habit"

    expect(page).to have_content("Habit created.")
    expect(page).to have_content("Morning walk")
    expect(page).to have_content("Walk before starting work")

    click_link "Edit"
    fill_in "Name", with: "Morning walk outside"
    fill_in "Goal count", with: "2"
    click_button "Update Habit"

    expect(page).to have_content("Habit updated.")
    expect(page).to have_content("Morning walk outside")
    expect(page).to have_content("2 times")

    click_button "Archive"

    expect(page).to have_content("Habit archived.")
    expect(page).to have_content("Morning walk outside")
    expect(page).to have_content("Archived")

    click_button "Delete"

    expect(page).to have_content("Habit deleted.")
    expect(page).to have_content("No habits yet")
  end
end
