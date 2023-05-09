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
  describe '#to_s' do
    let(:user) { create(:user, full_name: 'John Doe') }
    let(:outing) { create(:outing, name: 'Test Outing') }
    let(:participant) { create(:participant, user:, outing:, status: :pending) }

    it 'returns a string with the user full name, outing name, and status' do
      expect(participant.to_s).to eq('John Doe has been invited to Test Outing. Status: pending')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:outing) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(%i[pending confirmed rejected creator]) }

    it 'initializes status with pending by default' do
      participant = described_class.create(user: create(:user), outing: create(:outing))
      expect(participant.status).to eq('pending')
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:full_name).to(:user) }
  end
end
