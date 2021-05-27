class MerchantSoldItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
  attributes :count do |object|
    object.total_items_sold
  end
end
