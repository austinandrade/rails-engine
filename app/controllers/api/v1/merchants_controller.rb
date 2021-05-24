class Api::V1::MerchantsController < ApplicationController
  MAX_PAGINATION_LIMIT = 20

  def index
    merchant = Merchant.offset(page_number).limit(per_page)
    render json: MerchantSerializer.new(merchant)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  private

  def per_page
    params.fetch(:per_page, MAX_PAGINATION_LIMIT).to_i
  end

  def page_number
    page = [params.fetch(:page, 1).to_i, 1].max
    (page - 1) * per_page
  end
end
