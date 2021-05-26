class Api::V1::SearchController < ApplicationController
  def find_merchant
    merchant =
    Merchant.where("name Ilike ?", "%#{params[:name]}%")
    .order("LOWER(name)")
    .first
    if merchant.present?
      render json: MerchantSerializer.new(merchant)
    else
      blank_merchant = Merchant.create
      render json: MerchantSerializer.new(blank_merchant)
    end
  end

  def find_items
    items = Item.where("name Ilike ?", "%#{params[:name]}%")
    .order("LOWER(name)")
    render json: ItemSerializer.new(items)
  end
end
