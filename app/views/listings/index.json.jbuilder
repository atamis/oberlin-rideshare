json.array!(@listings) do |listing|
  json.extract! listing, :id, :user_id, :depart_maps_id, :depart_loc_id, :depart_range_start, :depart_range_end, :dest_maps_id, :dest_loc_id, :dest_range_start, :dest_range_end, :type, :money, :comments, :detour_time
  json.url listing_url(listing, format: :json)
end
