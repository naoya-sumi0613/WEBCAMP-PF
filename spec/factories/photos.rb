FactoryBot.define do

  factory :photo do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    word { Faker::Lorem.characters(number:10) }
    range { ['全ユーザー','フォロワーのみ','自分のみ'][rand(3)]}

    user
  end
end