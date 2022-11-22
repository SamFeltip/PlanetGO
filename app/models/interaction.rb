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
class Interaction < ApplicationRecord
end
