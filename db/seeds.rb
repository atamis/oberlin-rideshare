# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

["Grocery Store", "Liquor Store", "Pharmacy"].each do |name|
  puts "Making general location " + name
  GeneralLocation.new(name: name).save!
end

l = Listing.new
l.user = user
l.detour_time = 60
l.depart_maps_id = "ChIJ5fKhn34KOogRZuYN4JEy-to"
l.dest_maps_id = "ChIJ5fKhn34KOogRZuYN4JEy-to"
l.depart_range_start = DateTime.now
l.depart_range_end = DateTime.now + 2.hours
l.dest_range_start = DateTime.now + 4.hours
l.dest_range_end = DateTime.now + 5.hours

r = l.ride_requests.new
r.user = user
r.save! # Default undecided state
