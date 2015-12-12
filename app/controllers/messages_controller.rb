class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing
  before_action :set_ride_request
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # POST /messages
  # POST /messages.json
  def create
    @message = @ride_request.messages.new(message_params)
    @message.user = current_user

    respond_to do |format|
      if @message.save
        format.html { redirect_to :back, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :back }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_listing
      @listing = Listing.find(params['listing_id'])
    end

    def set_ride_request
      @ride_request = RideRequest.find(params['ride_request_id'])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:user_id, :ride_request_id, :body)
    end
end
