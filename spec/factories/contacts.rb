FactoryBot.define do

  factory :contact do
    title { "お問い合わせ" }
    content { "テストです" }

    user
  end
end