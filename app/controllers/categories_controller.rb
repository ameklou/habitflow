class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = policy_scope(current_user.categories).includes(:habits).order(:position, :name)
  end

  def show
    authorize @category
    @habits = @category.habits.order(archived_at: :asc, name: :asc)
  end

  def new
    @category = current_user.categories.build(color: "#2563eb")
    authorize @category
  end

  def create
    @category = current_user.categories.build(category_params)
    authorize @category

    if @category.save
      redirect_to @category, notice: "Category created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @category
  end

  def update
    authorize @category

    if @category.update(category_params)
      redirect_to @category, notice: "Category updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @category
    @category.destroy!

    redirect_to categories_path, notice: "Category deleted."
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :color, :icon, :position)
  end
end
