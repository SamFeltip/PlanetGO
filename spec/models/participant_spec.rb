# frozen_string_literal: true

# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  outing_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_participants_on_outing_id  (outing_id)
#  index_participants_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (outing_id => outings.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Participant do
  context 'when circumstances that create participants' do
    context 'when an outing has been created' do
      describe 'when an outing is created' do
        it 'creates a participant for the creator' do
          pending 'woarked on soon'
        end

        it 'makes participant with creator status' do
          pending 'worked on soon'
        end
      end
    end
  end
end
