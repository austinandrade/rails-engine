class Api::V1::SearchController < ApplicationController
  def find_merchant
    if params[:name] && params[:name].present?
      merchant = Merchant.find_match_by_name(params[:name]).first

      if merchant
        render json: MerchantSerializer.new(merchant)
      else
        blank_merchant = Merchant.create
        render json: MerchantSerializer.new(blank_merchant), status: :bad_request
      end
    else
      render json: { error: 'Please include name param' }.to_json, status: :bad_request
    end
  end

  def find_items
    if params[:name] && params[:name].present?
      items = Item.where('name Ilike ?', "%#{params[:name]}%")
                  .order('LOWER(name)')
      if items
        render json: ItemSerializer.new(items)
      end
    else
      render json: { error: 'Please include name param' }.to_json, status: :bad_request
    end
  end
end
