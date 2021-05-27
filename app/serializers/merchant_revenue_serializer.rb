class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :revenue do |object|
    object.total_revenue
  end
end
