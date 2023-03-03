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
    name { "My exciting adventure" }
    date { "2023-02-23" }
    description { "This is a really cool adventure, with all my friends!" }
  end
end
