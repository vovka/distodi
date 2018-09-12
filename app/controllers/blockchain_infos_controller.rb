class BlockchainInfosController < ApplicationController
  layout "item"

  def show
    @blockchain_info = BlockchainInfo.get_info(params[:hash])
  end
end
