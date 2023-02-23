# == Schema Information
#
# Table name: outings
#
#  id          :bigint           not null, primary key
#  date        :date
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :outing do
    name { "MyString" }
    date { "2023-02-23" }
    description { "MyText" }
  end
end
