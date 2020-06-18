FactoryBot.define do

  factory :contact do
    title { Faker::Lorem.characters(number:30) }
    content { Faker::Lorem.characters(number:100) }

    user
  end
end