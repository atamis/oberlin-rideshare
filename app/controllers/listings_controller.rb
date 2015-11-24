class ListingsController < ApplicationController
  require 'open-uri'
  before_action :authenticate_user!
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  
  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.all
    for listing in @listings
    	listing.depart_maps_id = get_address(listing.depart_maps_id)
        listing.dest_maps_id = get_address(listing.dest_maps_id)
    end
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    maps = MapsService.new
     @listing.depart_maps_id = maps.get_address(@listing.depart_maps_id)
     @listing.dest_maps_id = maps.get_address(@listing.dest_maps_id)
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.user_id = current_user.id
    
    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:depart_maps_id, :depart_loc_id, :depart_range_start, :depart_range_end, :dest_maps_id, :dest_loc_id, :dest_range_start, :dest_range_end, :listing_type, :money, :comments, :detour_time)
    end
end
