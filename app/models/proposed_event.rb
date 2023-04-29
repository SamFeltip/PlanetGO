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
class ProposedEvent < ApplicationRecord
  belongs_to :event
  belongs_to :outing

  has_many :participant_reactions, dependent: :destroy

  def reacted(participant, reaction)
    ParticipantReaction.exists?(participant_id: participant.id,
                                proposed_event_id: id,
                                reaction:)
  end

end