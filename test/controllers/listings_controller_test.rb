require 'test_helper'

class ListingsControllerTest < ActionController::TestCase
  setup do
    @listing = listings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:listings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create listing" do
    assert_difference('Listing.count') do
      post :create, listing: { comments: @listing.comments, depart_loc_id: @listing.depart_loc_id, depart_maps_id: @listing.depart_maps_id, depart_range: @listing.depart_range, depart_range_start: @listing.depart_range_start, dest_loc_id: @listing.dest_loc_id, dest_maps_id: @listing.dest_maps_id, dest_range_end: @listing.dest_range_end, dest_range_start: @listing.dest_range_start, detour_time: @listing.detour_time, money: @listing.money, type: @listing.type, user_id: @listing.user_id }
    end

    assert_redirected_to listing_path(assigns(:listing))
  end

  test "should show listing" do
    get :show, id: @listing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @listing
    assert_response :success
  end

  test "should update listing" do
    patch :update, id: @listing, listing: { comments: @listing.comments, depart_loc_id: @listing.depart_loc_id, depart_maps_id: @listing.depart_maps_id, depart_range: @listing.depart_range, depart_range_start: @listing.depart_range_start, dest_loc_id: @listing.dest_loc_id, dest_maps_id: @listing.dest_maps_id, dest_range_end: @listing.dest_range_end, dest_range_start: @listing.dest_range_start, detour_time: @listing.detour_time, money: @listing.money, type: @listing.type, user_id: @listing.user_id }
    assert_redirected_to listing_path(assigns(:listing))
  end

  test "should destroy listing" do
    assert_difference('Listing.count', -1) do
      delete :destroy, id: @listing
    end

    assert_redirected_to listings_path
  end
end
