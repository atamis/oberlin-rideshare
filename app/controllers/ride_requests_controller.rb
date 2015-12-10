class RideRequestsController < ApplicationController
  before_action :set_listing
  before_action :set_messages, only: [:show]
  before_action :set_ride_request, only: [:show, :edit, :update, :destroy, :accept, :reject]

  # GET /ride_requests
  # GET /ride_requests.json
  def index
    @ride_requests = @listing.ride_requests
  end

  # GET /ride_requests/1
  # GET /ride_requests/1.json
  def show
    authorize! :show, @ride_request
  end

  # GET /ride_requests/new
  def new
    @ride_request = @listing.ride_requests.new
    @ride_request.user = current_user
    authorize! :create, @ride_request
  end

  # GET /ride_requests/1/edit
  def edit
    authorize! :update, @ride_request
  end

  def accept
    @ride_request.state = :accepted
    authorize! :accept, @ride_request

    respond_to do |format|
      if @ride_request.save
        format.html { redirect_to [@listing, @ride_request], notice: 'Ride request was successfully created.' }
        format.json { render :show, status: :created, location: [@listing, @ride_request] }
      else
        format.html { render :new }
        format.json { render json: @ride_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def reject
    @ride_request.state = :rejected
    authorize! :accept, @ride_request

    respond_to do |format|
      if @ride_request.save
        format.html { redirect_to [@listing, @ride_request], notice: 'Ride request was successfully created.' }
        format.json { render :show, status: :created, location: [@listing, @ride_request] }
      else
        format.html { render :new }
        format.json { render json: @ride_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /ride_requests
  # POST /ride_requests.json
  def create
    @ride_request = @listing.ride_requests.new
    @ride_request.user = current_user
    @ride_request.state = :undecided
    authorize! :create, @ride_request

    respond_to do |format|
      if @ride_request.save
        format.html { redirect_to [@listing, @ride_request], notice: 'Ride request was successfully created.' }
        format.json { render :show, status: :created, location: [@listing, @ride_request] }
      else
        format.html { render :new }
        format.json { render json: @ride_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ride_requests/1
  # PATCH/PUT /ride_requests/1.json
  def update
    authorize! :update, @ride_request
    respond_to do |format|
      if @ride_request.update(ride_request_params)
        format.html { redirect_to [@listing, @ride_request], notice: 'Ride request was successfully updated.' }
        format.json { render :show, status: :ok, location: [@listing, @ride_request] }
      else
        format.html { render :edit }
        format.json { render json: @ride_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ride_requests/1
  # DELETE /ride_requests/1.json
  def destroy
    authorize! :destroy, @ride_request
    @ride_request.destroy
    respond_to do |format|
      format.html { redirect_to listing_ride_requests_url(@listing), notice: 'Ride request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_listing
      @listing = Listing.find(params['listing_id'])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_ride_request
      @ride_request = RideRequest.find(params[:id] || params[:ride_request_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_messages
      @messages = Message.where(ride_request_id: params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def ride_request_params
      params.require(:ride_request).permit(:listing_id, :user_id, :state)
    end
end
