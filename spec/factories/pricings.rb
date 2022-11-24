# == Schema Information
#
# Table name: pricings
#
#  id          :bigint           not null, primary key
#  description :string
#  price       :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :pricing do
    title { "MyString" }
    features { "MyString" }
    price { "MyString" }
  end
end
