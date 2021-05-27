class Api::V1::CalculationsController < ApplicationController
  def top_merchants
    if params[:quantity]
      best_merchants = Merchant.top_merchants_by_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(best_merchants)
    else
      render json: { error: 'Please include quantity param' }.to_json, status: 400
    end
  end
end
