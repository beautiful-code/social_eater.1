class Admin::CuisinesController < Admin::MainController

  before_action :set_cuisine, except: [:index]

  def index
    @cuisines = Cuisine.all
  end

  # POST /cuisines
  # POST /cuisines.json
  def create
    respond_to do |format|
      if @cuisine.save
        format.html { redirect_to [:admin,:cuisines], notice: 'cuisine was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cuisine }
      else
        format.html { render action: 'new' }
        format.json { render json: @cuisine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cuisines/1
  # PATCH/PUT /cuisines/1.json
  def update
    respond_to do |format|
      if @cuisine.update(cuisine_params)
        format.html { redirect_to [:admin,:cuisines], notice: 'cuisine was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cuisine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cuisines/1
  # DELETE /cuisines/1.json
  def destroy
    @cuisine.destroy
    respond_to do |format|
      format.html { redirect_to [:admin,:cuisines], notice: 'cuisine was destroyed successfully' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cuisine
      @cuisine = (params[:id].present?)? Cuisine.find(params[:id]) : Cuisine.new(cuisine_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cuisine_params
      params.fetch(:cuisine,{}).permit(:name)
    end
end
