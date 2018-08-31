FactoryBot.define do
  factory :user do
    name {Faker::LordOfTheRings.character}
    email {Faker::Internet.email}
    phone {Faker::PhoneNumber.phone_number}
    password {Faker::BreakingBad.character}
  end
end
