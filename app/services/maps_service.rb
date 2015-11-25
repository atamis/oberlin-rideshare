class MapsService
  require 'open-uri'
  attr_reader :secret

  def initialize
    @secret = Rails.application.secrets.maps_api_key
    if @secret.empty?
      raise "Maps API key set incorrectly"
    end
  end

  def get_address(place_id)
    if place_id.empty? or place_id.nil?
      return "ERROR"
    end
    
     puts "\tQuerying Google Maps API for address of place_ID: " + place_id
     request_start_time = Time.new
     response = JSON.parse(
     		     open("https://maps.googleapis.com/maps/api/geocode/json?place_id=" +
                     place_id +
                     "&key=" + @secret).read)
     request_duration = Time.new - request_start_time
     puts "\tGot response for query of place_ID: " + place_id + " (took: " + request_duration.inspect + " secs)"
    
     if response["status"] == "OK"
        return response["results"].first["formatted_address"]
     else
        puts response 
        return "ERROR"
     end
  end

end
