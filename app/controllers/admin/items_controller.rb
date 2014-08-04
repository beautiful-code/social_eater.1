class Admin::ItemsController < Admin::MainController
  before_action :set_place
  before_action :set_item, only: [:show, :edit, :update, :destroy, :vote]

  def show
  end

  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to [:admin,@place], notice: 'Item was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors
    end
  end

  def destroy
    @item.destroy
    redirect_to [:admin,@item.place], notice: 'Item was deleted successfully'
  end

  private
  def set_place
    @place = Place.find(params[:place_id])
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:place_id, :name, :desc, :price, :cold_votes, :seasonal, :non_veg, :category_id, :tag)
  end
end
