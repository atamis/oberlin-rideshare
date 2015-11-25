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



   def get_driving_time(locations)
        if locations.nil? or locations.empty?
          return false
        end
	   
        if locations.length < 2
          return false
        end
        request_url = "https://maps.googleapis.com/maps/api/directions/json?key=" + @secret
        for i in 0..locations.length-1
      	   if i == 0
              request_url = request_url + "&origin=place_id:" + locations[i]
           elsif i == 1 and i != locations.length-1
              request_url = request_url + "&waypoints=place_id:" + locations[i]
           elsif i != locations.length-1
              request_url = request_url + "|place_id:" + locations[i]
           else
              request_url = request_url + "&destination=place_id:" + locations[i]
           end
        end
       
        response = JSON.parse(open(request_url).read)
       
        if response["status"] != "OK"
           return false
        end
         
        travel_time = false

        for route in response["routes"]
           route_travel_time = 0
           for leg in route["legs"]
             route_travel_time += leg["duration"]["value"]
           end
 
           if travel_time == false or route_travel_time < travel_time
             travel_time = route_travel_time
           end
        end
     
        return travel_time; 
       
   end

end
