class Api::V1::SearchController < ApplicationController
  def find_merchant
    merchant =
    Merchant.where("name Ilike ?", "%#{params[:name]}%")
    .order("LOWER(name)")
    .first
    if merchant.present?
      render json: MerchantSerializer.new(merchant)
    else
      merchant = Merchant.create
      render json: MerchantSerializer.new(merchant)
    end
  end
end
