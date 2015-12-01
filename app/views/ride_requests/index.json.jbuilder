json.array!(@ride_requests) do |ride_request|
  json.extract! ride_request, :id, :listing_id, :user_id, :state
  json.url ride_request_url(ride_request, format: :json)
end
