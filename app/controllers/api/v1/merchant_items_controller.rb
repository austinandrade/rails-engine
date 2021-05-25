class Api::V1::MerchantItemsController < ApplicationController
  MAX_PAGINATION_LIMIT = 20

  def index
    merchant = Merchant.find(params[:id])
    render json: ItemSerializer.new(merchant.items)
  end
end
