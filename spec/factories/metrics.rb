# == Schema Information
#
# Table name: metrics
#
#  id                  :bigint           not null, primary key
#  is_logged_in        :boolean
#  latitude            :float
#  longitude           :float
#  number_interactions :integer
#  pricing_selected    :integer
#  route               :string
#  time_enter          :datetime
#  time_exit           :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :metric do
    time_enter { "2022-11-24 12:24:16" }
    time_exit { "2022-11-24 12:24:16" }
    route { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
    is_logged_in { false }
    number_interactions { 1 }
    pricing_selected { 1 }
  end
end
