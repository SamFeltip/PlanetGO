# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  approved      :boolean
#  category      :integer
#  description   :text
#  name          :string
#  time_of_event :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

# RSpec.describe Event do
#   let!(:event_creator) { create(:user) }
#   let(:created_event) { create(:event, user_id: event_creator) }
#   # let!(:other_event_creator) { create(:user) }
#
#   describe '#pending_events' do
#     specify 'returns all pending events' do
#       events = described_class.my_pending_events(event_creator)
#       expect(events.count).to eq(1)
#     end
#   end
# end
