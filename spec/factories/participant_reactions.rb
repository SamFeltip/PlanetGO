# == Schema Information
#
# Table name: participant_reactions
#
#  id                :bigint           not null, primary key
#  reaction          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  participant_id    :bigint           not null
#  proposed_event_id :bigint           not null
#
# Indexes
#
#  index_participant_reactions_on_participant_id     (participant_id)
#  index_participant_reactions_on_proposed_event_id  (proposed_event_id)
#
# Foreign Keys
#
#  fk_rails_...  (participant_id => participants.id)
#  fk_rails_...  (proposed_event_id => proposed_events.id)
#
FactoryBot.define do
  factory :participant_reaction do
    participant { nil }
    proposed_event { nil }
    reaction { 1 }
  end
end
