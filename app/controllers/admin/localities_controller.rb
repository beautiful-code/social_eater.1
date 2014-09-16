class Admin::LocalitiesController < Admin::MainController

  before_action :set_locality, except: [:index]

  def index
    @localities = Locality.all
  end

  # POST /localities
  # POST /localities.json
  def create
    respond_to do |format|
      if @locality.save
        format.html { redirect_to [:admin,:localities], notice: 'Locality was successfully created.' }
        format.json { render action: 'show', status: :created, location: @locality }
      else
        format.html { render action: 'new' }
        format.json { render json: @locality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /localities/1
  # PATCH/PUT /localities/1.json
  def update
    respond_to do |format|
      if @locality.update(locality_params)
        format.html { redirect_to [:admin,:localities], notice: 'Locality was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @locality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /localities/1
  # DELETE /localities/1.json
  def destroy
    @locality.destroy
    respond_to do |format|
      format.html { redirect_to [:admin,:localities], notice: 'Locality was destroyed successfully' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_locality
      @locality = (params[:id].present?)? Locality.find(params[:id]) : Locality.new(locality_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def locality_params
      params.fetch(:locality,{}).permit(:area_name, :city, :Latitude, :Longitude)
    end
end
