# frozen_string_literal: true

# == Schema Information
#
# Table name: event_reacts
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_event_reacts_on_event_id  (event_id)
#  index_event_reacts_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe EventReact do
  describe '#to_s' do
    let(:user) { create(:user, full_name: 'John Doe') }
    let(:event) { create(:event, name: 'Test Event') }
    let(:event_react) { create(:event_react, user:, event:) }

    it 'returns a string with the user full name and event name' do
      expect(event_react.to_s).to eq('John Doe liked Test Event')
    end
  end
end
