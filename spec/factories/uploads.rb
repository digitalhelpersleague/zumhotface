FactoryGirl.define do

  factory :link, class: Upload::Link do
    link { Faker::Internet.url }
  end

  factory :code, class: Upload::Code do
    code { Faker::Lorem.sentence }
  end

  factory :blob, class: Upload::Blob do
  end
end
