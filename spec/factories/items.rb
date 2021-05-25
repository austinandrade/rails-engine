FactoryBot.define do
  factory :item do
    name { Faker::Games::Witcher.potion }
    description { Faker::Games::Witcher.quote }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    association :merchant, factory: :merchant
  end
end
