class ItemsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_place
  before_action :set_item, only: [:show, :edit, :update, :destroy, :vote]

  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

      if @item.save
        redirect_to @place, notice: 'Item was successfully created.'
      else
        render action: 'new'
      end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item.place, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end


  #->Prelang (voting/acts_as_votable)
  def vote
    current_user.likes @item

    redirect_to request.referrer
  end


  private
    def set_place
      @place = Place.find(params[:place_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:place_id, :name, :desc, :price)
    end
end
