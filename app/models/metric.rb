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
class Metric < ApplicationRecord
end
