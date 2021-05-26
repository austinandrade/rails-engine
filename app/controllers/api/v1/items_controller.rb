class Api::V1::ItemsController < ApplicationController
  include Pagination

  def index
    items = Item.offset(page_number).limit(per_page)
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    created_item = Item.create!(item_params)
    render json: ItemSerializer.new(created_item), status: :created
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: { error: 'Not Found' }.to_json, status: :not_found
    end
  end

  def destroy
    Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
