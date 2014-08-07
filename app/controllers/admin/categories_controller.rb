class Admin::CategoriesController < Admin::MainController

  before_action :set_place
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to [:admin, @place], notice: 'Category was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    if @category.update(category_params)
      redirect_to [:admin, @category.place], notice: 'Category was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    if @category.destroy
      redirect_to [:admin,@category.place], notice: 'Category was deleted successfully'
    else
      redirect_to [:admin,@category.place], alert: 'Unable to delete category.'
    end
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:place_id, :name, :tags, :position, :cold_votes)
  end
end
