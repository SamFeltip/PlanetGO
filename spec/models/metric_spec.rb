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
require 'rails_helper'
