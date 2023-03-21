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

# RSpec.describe ProposedEvent do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
