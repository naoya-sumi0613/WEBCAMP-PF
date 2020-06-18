FactoryBot.define do

  factory :user do

    gimei = Gimei.name

    last_name { gimei.last.kanji }
    read_last_name { gimei.last.katakana }
    full_name { "" }
    first_name { gimei.first.kanji }
    read_first_name { gimei.first.katakana }
    read_full_name { "" }
    email { Faker::Internet.email }
    password { "password" }
  end
end