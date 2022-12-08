# == Schema Information
#
# Table name: register_interests
#
#  id              :bigint           not null, primary key
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pricing_id      :string
#  pricing_plan_id :string
#
FactoryBot.define do
  factory :register_interest do
    email { "MyString" }
    pricing_id { "MyString" }
  end
end
