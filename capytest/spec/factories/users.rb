FactoryBot.define do
  factory :user do
    username { Faker::Music::RockBand.name }
    password { Faker::Games::DnD.monster }
  end
end
