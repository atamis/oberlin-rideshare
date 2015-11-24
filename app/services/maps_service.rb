class MapsService
  def initialize
  end

  def get_address(place_id)
    if place_id.empty? or place_id.nil?
      return "ERROR"
    end

     response = open("https://maps.googleapis.com/maps/api/geocode/json?place_id="
                     + place_id +
                       "&key=" + Rails.application.secrets.maps_api_key).read
                     .tap { |str| JSON.parse }

     if response["status"] == "OK"
        return response["results"].first["formatted_address"]
     else
        return "ERROR"
     end
  end

end
