class Api::V1::MerchantsController < ApplicationController
  include Pagination

  def index
    merchants = Merchant.offset(page_number).limit(per_page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
end
