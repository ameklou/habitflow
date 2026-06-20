require "rails_helper"

RSpec.describe "Habit completion", type: :system do
  before do
    driven_by :rack_test
  end

  it "lets a user complete and undo a habit for today" do
    user = create(:user, password: "password123")
    create(:habit, user: user, name: "Drink water")

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    click_link "Habits"

    expect(page).to have_content("Remaining")
    expect(page).to have_content("1")

    fill_in "Completion note", with: "Finished before lunch"
    click_button "Complete today"

    expect(page).to have_content("Habit completed.")
    expect(page).to have_content("Completed")
    expect(page).to have_content("Note: Finished before lunch")

    click_button "Undo completion"

    expect(page).to have_content("Completion undone.")
    expect(page).to have_button("Complete today")
    expect(HabitCompletion.count).to eq(0)
  end
end
