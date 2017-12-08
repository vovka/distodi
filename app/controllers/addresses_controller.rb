class AddressesController < ApplicationController
  respond_to :json

  def search
    addresses = Geocoder.search(params[:q])
    respond_with addresses
  end
end
