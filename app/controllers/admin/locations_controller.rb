require "httparty"

class LocationsController < ApplicationController
  protect_from_forgery except: :create

  def index
    @locations = Location.all
  end

  def create
    location = Location.new(location_params)
    location.save
    render json: {}, status: :ok
  end

  def location_params
    params.require(:family).permit(:address)
  end

  def search
    if params[:address].present?
      geocoder = Geocoder.search(params[:address])
      @search_result_address = geocoder[0].formatted_address

      location = geocoder[0].geometry['location']
      @candidate_hash = Location.candidate_list(location)
    end
  end

end
