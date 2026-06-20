require "rails_helper"

RSpec.describe "Category management", type: :system do
  before do
    driven_by :rack_test
  end

  it "lets a user create, edit, assign, and delete a category" do
    user = create(:user, password: "password123")

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    click_link "Categories"
    click_link "New category"

    fill_in "Name", with: "Health"
    fill_in "Icon", with: "heart"
    fill_in "Position", with: "1"
    click_button "Create Category"

    expect(page).to have_content("Category created.")
    expect(page).to have_content("Health")

    click_link "Edit"
    fill_in "Name", with: "Fitness"
    fill_in "Position", with: "2"
    click_button "Update Category"

    expect(page).to have_content("Category updated.")
    expect(page).to have_content("Fitness")
    expect(page).to have_content("Position 2")

    click_link "New habit"
    fill_in "Name", with: "Morning run"
    select "Fitness", from: "Category"
    click_button "Create Habit"

    expect(page).to have_content("Habit created.")
    expect(page).to have_content("Category")
    expect(page).to have_content("Fitness")

    click_link "Categories"
    click_link "Fitness"
    expect(page).to have_content("Morning run")

    click_button "Delete"

    expect(page).to have_content("Category deleted.")
    expect(page).to have_content("No categories yet")
    expect(Habit.last.category).to be_nil
  end
end
