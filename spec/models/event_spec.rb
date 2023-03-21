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

require 'rails_helper'

RSpec.describe Event do
  context 'when viewing events' do
    describe 'when a user can view all open events' do
      it 'shows the titles of events' do
        pending 'not developed yet'
      end
    end
  end
end
