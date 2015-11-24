class MapsService
  require 'open-uri'
  attr_reader :secret

  def initialize
    @secret = Rails.application.secrets.maps_api_key
    if @secret == "THIS_IS_NOT_A_VALID_KEY"
      raise "Maps API key set incorrectly"
    end
  end

  def get_address(place_id)
    if place_id.empty? or place_id.nil?
      return "ERROR"
    end

     response = open("https://maps.googleapis.com/maps/api/geocode/json?place_id=" +
                     place_id +
                     "&key=" + @secret).read
                     .tap { |str| JSON.parse }

     if response["status"] == "OK"
        return response["results"].first["formatted_address"]
     else
        return "ERROR"
     end
  end

end
