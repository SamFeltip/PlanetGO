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

RSpec.describe Event do
  let(:event_creator) { create(:user) }
  let(:other_event_creator) { create(:user) }

  let!(:my_event) { create(:event, user_id: event_creator.id) }
  let!(:other_event) { create(:event, user_id: other_event_creator.id) }


  describe '#my_pending_events' do

    context 'with my events' do
      let!(:my_approved_event) { create(:event, approved: true, user_id: event_creator.id) }

      it 'does not include my approved events' do
        expect(described_class.my_pending_events(event_creator)).to_not include(my_approved_event)
      end

      it 'returns all my pending events' do
        expect(described_class.my_pending_events(event_creator)).to include(my_event)
      end
    end

    context 'with other events' do
      it 'does not include other pending events' do
        expect(described_class.my_pending_events(event_creator)).to_not include(other_event)
      end
    end
  end

  describe '#other_users_pending_events' do

    context 'with my events' do
      it 'does not include my pending events' do
        expect(described_class.other_users_pending_events(event_creator)).to_not include(my_event)
      end
    end

    context 'with other events' do
      let!(:other_approved_event) { create(:event, approved: true, user_id: other_event_creator.id) }

      it 'returns all other pending events' do
        expect(described_class.other_users_pending_events(event_creator)).to include(other_event)
      end

      it 'does not include approved events' do
        expect(described_class.other_users_pending_events(event_creator)).to_not include(other_approved_event)
      end
    end

  end
end
