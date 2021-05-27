class Api::V1::SearchController < ApplicationController
  def find_merchant
    if params[:name] && params[:name].present?
      merchant =
      Merchant.where('name Ilike ?', "%#{params[:name]}%")
      .order('LOWER(name)')
      .first

      if merchant
        render json: MerchantSerializer.new(merchant)
      else
        blank_merchant = Merchant.create
        render json: MerchantSerializer.new(blank_merchant), status: 400
      end
    else
      render json: { error: 'Please include name param' }.to_json, status: 400
    end
  end

  def find_items
    if params[:name] && params[:name].present?
      items = Item.where('name Ilike ?', "%#{params[:name]}%")
                  .order('LOWER(name)')
      if items
        render json: ItemSerializer.new(items)
      else
        blank_item = Item.create
        render json: ItemSerializer.new(blank_item), status: 400
      end
    else
      render json: { error: 'Please include name param' }.to_json, status: 400
    end
  end
end
