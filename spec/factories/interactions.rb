# == Schema Information
#
# Table name: interactions
#
#  id                               :bigint           not null, primary key
#  lattitude                        :float
#  logged_in                        :boolean
#  longitude                        :float
#  num_interactions_on_splashscreen :integer
#  start_splashscreen               :datetime
#  start_visit                      :datetime
#  time_on_splashscreen             :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
FactoryBot.define do
  factory :interaction do
    logged_in { false }
    start_visit { "2022-11-22 14:39:42" }
    lattitude { 1.5 }
    longitude { 1.5 }
    start_splashscreen { "2022-11-22 14:39:42" }
    time_on_splashscreen { 1 }
    num_interactions_on_splashscreen { 1 }
  end
end
