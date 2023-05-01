# frozen_string_literal: true

# == Schema Information
#
# Table name: metrics
#
#  id                  :bigint           not null, primary key
#  country_code        :string
#  is_logged_in        :boolean
#  latitude            :float
#  longitude           :float
#  number_interactions :integer
#  route               :string
#  time_enter          :datetime
#  time_exit           :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :metric do
    time_enter { '2022-11-24 12:24:16' }
    time_exit { '2022-11-24 12:24:16' }
    route { '/' }
    latitude { 53.376347 }
    longitude { -1.488364 }
    country_code { 'GB' }
    is_logged_in { false }
    number_interactions { 1 }
  end
end
