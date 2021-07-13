class Api::V1::SearchController < ApplicationController
  def find_merchant
    if params[:name]&.present?
      merchant = Merchant.find_match_by_name(params[:name]).first
      render json: MerchantSerializer.new(merchant) if merchant.present?
      render json: MerchantSerializer.new(Merchant.create), status: :bad_request if merchant.nil?
      # I would have just created a no found error for this
      # render json: { error: 'Merchant not found' }.to_json, status: :not_found if merchant.nil?
    else
      render json: { error: 'Please include name param' }.to_json, status: :bad_request
    end
  end

  def find_items
    if params[:name]&.present?
      items = Item.find_match_by_name(params[:name])
      render json: ItemSerializer.new(items) if items
    else
      render json: { error: 'Please include name param' }.to_json, status: :bad_request
    end
  end
end
