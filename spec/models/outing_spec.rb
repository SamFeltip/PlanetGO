# frozen_string_literal: true

# == Schema Information
#
# Table name: outings
#
#  id               :bigint           not null, primary key
#  date             :date
#  description      :text
#  invitation_token :bigint
#  name             :string
#  outing_type      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  creator_id       :bigint
#
# Indexes
#
#  index_outings_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
require 'rails_helper'

# RSpec.describe Outing do
#   context 'when an outing is being created' do
#     describe 'when creating a participant with my user_id' do
#       it 'sets participant as "creator"' do
#         pending 'not developed yet'
#       end
#     end
#   end
# end
