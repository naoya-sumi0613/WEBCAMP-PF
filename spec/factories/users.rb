FactoryBot.define do

  factory :user do
    last_name { "手須戸" }
    read_last_name { "テスト" }
    full_name { "" }
    first_name { "太郎" }
    read_first_name { "タロウ" }
    read_full_name { "" }
    email { "tesuto@tarou" }
    password { "tesuto" }
  end
end