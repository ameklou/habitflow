require "rails_helper"

RSpec.describe "Categories", type: :request do
  let(:user) { create(:user) }

  describe "GET /categories" do
    it "requires authentication" do
      get categories_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "lists only the current user's categories" do
      create(:category, user: user, name: "Health")
      create(:category, name: "Private category")

      sign_in user
      get categories_path

      expect(response.body).to include("Health")
      expect(response.body).not_to include("Private category")
    end
  end

  describe "GET /categories/:id" do
    it "does not expose another user's category" do
      other_category = create(:category)

      sign_in user
      get category_path(other_category)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /categories" do
    it "creates a category for the current user" do
      sign_in user

      expect do
        post categories_path, params: {
          category: {
            name: "Health",
            color: "#16a34a",
            icon: "heart",
            position: 1
          }
        }
      end.to change(user.categories, :count).by(1)

      expect(response).to redirect_to(category_path(Category.last))
      expect(Category.last.name).to eq("Health")
    end

    it "renders validation errors" do
      sign_in user

      post categories_path, params: { category: { name: "", color: "#16a34a", position: 0 } }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Name can")
      expect(response.body).to include("be blank")
    end
  end

  describe "PATCH /categories/:id" do
    it "updates the current user's category" do
      category = create(:category, user: user, name: "Health")
      sign_in user

      patch category_path(category), params: { category: { name: "Fitness", position: 2 } }

      expect(response).to redirect_to(category_path(category))
      expect(category.reload.name).to eq("Fitness")
      expect(category.position).to eq(2)
    end
  end

  describe "DELETE /categories/:id" do
    it "deletes the current user's category and leaves habits uncategorized" do
      category = create(:category, user: user)
      habit = create(:habit, user: user, category: category)
      sign_in user

      expect do
        delete category_path(category)
      end.to change(user.categories, :count).by(-1)

      expect(response).to redirect_to(categories_path)
      expect(habit.reload.category).to be_nil
    end
  end
end
