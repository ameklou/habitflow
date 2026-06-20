require "rails_helper"

RSpec.describe "Dashboard and stats", type: :system do
  before do
    driven_by :rack_test
  end

  it "shows today's habits and historical stats" do
    user = create(:user, password: "password123")
    habit = create(:habit, user: user, name: "Morning stretch", created_at: 2.days.ago)
    create(:habit_completion, habit: habit, completed_on: Time.zone.today)
    create(:habit_completion, habit: habit, completed_on: Time.zone.yesterday)

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    click_link "Dashboard"

    expect(page).to have_content("Dashboard")
    expect(page).to have_content("Morning stretch")
    expect(page).to have_content("Current streak")
    expect(page).to have_content("Weekly summary")

    click_link "View stats"

    expect(page).to have_content("Stats")
    expect(page).to have_content("Current streak")
    expect(page).to have_content("Longest streak")
    expect(page).to have_content("Last 7 days")
    expect(page).to have_content("Last 30 days")
  end
end
