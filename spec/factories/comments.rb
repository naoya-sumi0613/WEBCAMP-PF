FactoryBot.define do

  factory :comment do
    comment { Faker::Lorem.characters(number:30) }

    user
    photo
  end
end