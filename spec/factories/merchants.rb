FactoryBot.define do
  factory :merchant do
    name { Faker::Music::Hiphop.artist }
  end
end
