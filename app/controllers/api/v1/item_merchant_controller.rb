class Api::V1::ItemMerchantController < ApplicationController
  def show
    item = Item.find(params[:id])
    merchant = item.merchant
    render json: MerchantSerializer.new(merchant)
  end
end
