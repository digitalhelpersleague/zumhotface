FactoryGirl.define do

  factory :link, class: Upload::Link do
    link { Faker::Internet.url }
  end

  factory :code, class: Upload do
    code { Faker::Internet.url }
  end
end
