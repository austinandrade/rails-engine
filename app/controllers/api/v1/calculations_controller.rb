class Api::V1::CalculationsController < ApplicationController
  def top_merchants
    if params[:quantity]
      best_merchants = Merchant.top_merchants_by_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(best_merchants)
    else
      render json: { error: 'Please include quantity param' }.to_json, status: 400
    end
  end

  def merchant_total_revenue
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(merchant)
  end

  def top_item_selling_merchants
    if params[:quantity]
      top_selling_merchants = Merchant.best_item_selling_merchants(params[:quantity])
      render json: MerchantSoldItemSerializer.new(top_selling_merchants)
    else
      render json: { error: 'Please include quantity param' }.to_json, status: 400
    end
  end
end
