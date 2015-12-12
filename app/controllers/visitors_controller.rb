class VisitorsController < ApplicationController
  def index
    if current_user
      redirect_to listings_search_path
    end
  end
end
