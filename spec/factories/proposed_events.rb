# frozen_string_literal: true

# == Schema Information
#
# Table name: proposed_events
#
#  id                      :bigint           not null, primary key
#  cached_votes_down       :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_total      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  proposed_datetime       :datetime
#  status                  :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  event_id                :bigint           not null
#  outing_id               :bigint           not null
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
FactoryBot.define do
  factory :proposed_event do
    event { nil }
    outing { nil }
    proposed_datetime { '2023-02-24' }
    status { 1 }
  end
end
