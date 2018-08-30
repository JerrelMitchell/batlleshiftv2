FactoryBot.define do
  factory :user do
    username { "stephen" }
    email { "stephen@email.com" }
    password { "supsecret" }
    status { 1 }
    auth_token { "MyString" }
    activation_token { "MyString" }
  end
end
