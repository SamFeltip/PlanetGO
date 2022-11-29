# == Schema Information
#
# Table name: register_interests
#
#  id         :bigint           not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :register_interest do
    email { "MyString" }
  end
end
