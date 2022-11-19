# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :review do
    body { "MyText" }
  end
end
