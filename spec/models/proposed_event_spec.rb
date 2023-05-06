# frozen_string_literal: true

# == Schema Information
#
# Table name: proposed_events
#
#  id                :bigint           not null, primary key
#  proposed_datetime :datetime
#  status            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  event_id          :bigint           not null
#  outing_id         :bigint           not null
#
# Indexes
#
#  index_proposed_events_on_event_id   (event_id)
#  index_proposed_events_on_outing_id  (outing_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (outing_id => outings.id)
#
require 'rails_helper'

RSpec.describe ProposedEvent do
  # create an event
  let(:outing_creator) { create(:user) }
  let(:event_creator) { create(:user) }

  let(:event) { create(:event, user_id: event_creator.id) }
  # create an outing
  let(:outing) { create(:outing, creator_id: outing_creator.id) }

  # create a proposed event
  let(:proposed_event) { create(:proposed_event, event_id: event.id, outing_id: outing.id) }
  let(:proposed_event2) { create(:proposed_event, event_id: event.id, outing_id: outing.id) }

  let(:participant_user1) { create(:user) }
  let(:participant_user2) { create(:user) }

  let!(:participant1) { create(:participant, user_id: participant_user1.id, outing_id: outing.id) }
  let!(:participant2) { create(:participant, user_id: participant_user2.id, outing_id: outing.id) }

  describe '#failed_vote' do
    before do
      proposed_event.liked_by(participant1.user)
    end

    context 'when the proposed event has less than half of the outing participants votes' do
      it 'returns true' do
        expect(proposed_event.failed_vote).to be(true)
      end
    end

    context 'when the proposed event has more than half of the outing participants votes' do
      before do
        proposed_event.liked_by(participant2.user)
      end

      it 'returns false' do
        expect(proposed_event.failed_vote).to be(false)
      end
    end
  end
end
