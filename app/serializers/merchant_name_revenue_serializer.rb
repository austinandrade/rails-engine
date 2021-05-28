class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
  attributes :revenue do |object|
    object.total_revenue
  end
end
