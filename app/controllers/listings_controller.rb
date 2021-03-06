class ListingsController < ApplicationController
  require 'open-uri'
  before_action :authenticate_user!
  before_action :set_listing, only: [:show, :disable, :edit, :update, :destroy]

  def search
  end

  # GET /listings
  # GET /listings.json
  def index
    @listings
    @maps = MapsService.new
    hasErrorOccured = false
    if search_params.has_key?("type") and (search_params["type"] == "request" or search_params["type"] == "offer")
      puts search_params
      #@listings = Listing.where(listing_type: Listing.listing_types[params["type"]])
      depart_time_range_begin = search_params["depart_time_range_begin"]
      depart_time_range_end = search_params["depart_time_range_end"]
      return_time_range_begin = search_params["return_time_range_begin"]
      return_time_range_end = search_params["return_time_range_end"]

      detour_time= search_params["detour_time"]
      listing_type = search_params["type"]
      destination_location = search_params["destination_location"]
      depart_location = search_params["depart_location"]

      if !depart_time_range_begin.nil?
        begin
          depart_time_range_begin = DateTime.parse(depart_time_range_begin)
        rescue ArgumentError
          hasErrorOccured = true
          depart_time_range_begin = nil
        end
      end

      if !depart_time_range_end.nil?
        begin
          depart_time_range_end = DateTime.parse(depart_time_range_end)
        rescue ArgumentError
          hasErrorOccured = true
          depart_time_range_end = nil
        end
      end
      if !return_time_range_begin.nil?
        begin
          return_time_range_begin = DateTime.parse(returntime_range_begin)
        rescue ArgumentError
          hasErrorOccured = true
          return_time_range_begin = nil
        end
      end
      if !return_time_range_end.nil?
        begin
          return_time_range_end = DateTime.parse(return_time_range_end)
        rescue ArgumentError
          hasErrorOccured = true
          return_time_range_end= nil
        end
      end


      if !detour_time.nil?
        begin 
          detour_time = detour_time.to_i
        rescue ArgumentError
          detour_time = nil
        end
      end 

      if detour_time.nil? and listing_type == "request"
        hasErrorOccured = true
      end
      if !destination_location.nil? and destination_location.empty?
        destination_location = nil
        hasErrorOccured = true
      end

      if !depart_location.nil? and depart_location.empty?
        depart_location = nil
        hasErrorOccured = true
      end


      if hasErrorOccured
        respond_to do |format|
          format.html { redirect_to listings_search_url, notice: 'There was a problem with your search parameters.' and return } 
        end
      end

      # puts @maps.get_driving_time([departure_location, destination_location])
      # puts @maps.get_driving_time(["ChIJ5fKhn34KOogRZuYN4JEy-to", "ChIJF-40a4agMIgR80oyLiokn5A","ChIJJ_XOD3kKOogRJiAlB2KXI_A" ,"ChIJGytdNBsKOogR9lS0PwCA2Fg"], Time.now.to_i)
      # @listings = Listing.where("listing_type = ? AND ((depart_range_start >= ? AND depart_range_start <= ?) OR (depart_range_end >= ? AND depart_range_end <= ?))", Listing.listing_types[listing_type], depart_time_range_begin, depart_time_range_end, depart_time_range_begin, depart_time_range_end)

      @pre_listings = Listing.where(listing_type: Listing.listing_types[listing_type]).where(disabled: false)
      puts @pre_listings.inspect
      @listings = []
      for listing in @pre_listings
        if listing.listing_type == "offer"
          detour_time = listing.detour_time
        end 

        departure_time = listing.depart_range_start
        if departure_time < DateTime.now
          departure_time = DateTime.now
        end

        direct_travel_time_object = nil   
        detoured_travel_time_object = nil
        if listing_type == "offer"
          direct_travel_time_object = @maps.get_driving_time([listing.depart_maps_id, listing.dest_maps_id], departure_time.to_i)
          detoured_travel_time_object = @maps.get_driving_time([listing.depart_maps_id, depart_location, destination_location, listing.dest_maps_id], departure_time.to_i)
        elsif listing_type == "request"
          if direct_travel_time_object.nil?
            direct_travel_time_object = @maps.get_driving_time([depart_location, destination_location], departure_time.to_i)
          end
          detoured_travel_time_object = @maps.get_driving_time([depart_location, listing.depart_maps_id, listing.dest_maps_id, destination_location], departure_time.to_i)
        end

        puts "direct travel time: " + direct_travel_time_object[0].to_s
        puts "detoured travel time: " + detoured_travel_time_object[0].to_s

        puts detoured_travel_time_object[1]
        if ((detoured_travel_time_object[0] - direct_travel_time_object[0])/60) > detour_time
	   next
        end

        first_leg_time = detoured_travel_time_object[1][0] 


        if listing_type == "offer"
          if ((listing.depart_range_start+first_leg_time >= depart_time_range_begin and
               listing.depart_range_start+first_leg_time <= depart_time_range_end) or
                  (listing.depart_range_end+first_leg_time >= depart_time_range_begin and
                   listing.depart_range_end+first_leg_time <= depart_time_range_end))
            @listings << listing
            #listing.comments = listing.comments + " OUT OF TIME RANGE. first leg takes (mins): " + (first_leg_time/60).to_s
            puts listing.depart_range_start
            puts depart_time_range_begin
            puts listing.depart_range_start+first_leg_time
          end
        elsif listing_type == "request"
          if ((depart_time_range_begin+first_leg_time.seconds <= listing.depart_range_start and depart_time_range_end+first_leg_time.seconds >= listing.depart_range_start) or (depart_time_range_begin+first_leg_time.seconds <= listing.depart_range_end and depart_time_range_end+first_leg_time.seconds >= listing.depart_range_end))
            #listing.comments = listing.comments + " OUT OF TIME RANGE. first leg takes (mins): " + (first_leg_time/60).to_s
            @listings << listing
          end
        end
      end
    else
      @listings = Listing.where(disabled: false)
    end
    for listing in @listings
      listing.depart_maps_id = @maps.get_address(listing.depart_maps_id)
      listing.dest_maps_id = @maps.get_address(listing.dest_maps_id)
    end
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    @maps = MapsService.new
    @listing.depart_maps_id = @maps.get_address(@listing.depart_maps_id)
    @listing.dest_maps_id = @maps.get_address(@listing.dest_maps_id)
  end

  # GET /listings/new
  def new
    @maps = MapsService.new
    @listing = Listing.new(user: current_user)
    authorize! :create, @listing
  end

  # GET /listings/1/edit
  def edit
    authorize! :update, @listing
    @maps = MapsService.new
  end

  def disable
    authorize! :change, @listing
    @listing.disabled = true

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully disabled.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.user_id = current_user.id

    authorize! :create, @listing

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
    authorize! :update, @listing
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
    authorize! :destroy, @lisitng
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_listing
    @listing = Listing.find(params[:id] || params[:listing_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def listing_params
    params.require(:listing).permit(:depart_maps_id, :depart_loc_id, :depart_range_start, :depart_range_end, :dest_maps_id, :dest_loc_id, :dest_range_start, :dest_range_end, :listing_type, :money, :comments, :detour_time)
  end
  def search_params
    params.permit(:type, :depart_time_range_begin, :depart_time_range_end, :return_time_range_begin, :return_time_range_end, :detour_time, :depart_location, :destination_location)
  end
end
