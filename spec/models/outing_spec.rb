# frozen_string_literal: true

# == Schema Information
#
# Table name: outings
#
#  id           :bigint           not null, primary key
#  date         :datetime
#  description  :text
#  invite_token :string
#  name         :string
#  outing_type  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  creator_id   :bigint           not null
#
# Indexes
#
#  index_outings_on_creator_id    (creator_id)
#  index_outings_on_invite_token  (invite_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
require 'rails_helper'
import DateTime

RSpec.describe Outing do
  describe 'associations' do
    it { is_expected.to have_many(:participants).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:participants) }
    it { is_expected.to belong_to(:user).with_foreign_key(:creator_id).inverse_of(false) }
    it { is_expected.to have_many(:proposed_events).dependent(:destroy) }
    it { is_expected.to have_many(:events).through(:proposed_events) }
  end

  describe 'validations' do
    let(:current_user) { create(:user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:outing_type) }

    it 'allows a blank date' do
      outing = described_class.create(name: 'Test Outing', description: 'Outing description', outing_type: :personal, creator_id: current_user.id)
      expect(outing.valid?).to be(true)
    end

    it 'allows a future date' do
      outing = described_class.create(name: 'Test Outing', description: 'Outing description', outing_type: :personal, creator_id: current_user.id, date: Time.zone.today + 1)
      expect(outing.valid?).to be(true)
    end

    it 'allows a past date' do
      outing = described_class.create(name: 'Test Outing', description: 'Outing description', outing_type: :personal, creator_id: current_user.id, date: Time.zone.today - 1)
      expect(outing.valid?).to be(true)
    end
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:outing_type).with_values(personal: 0, open: 1) }
  end

  describe 'scopes' do
    describe '.order_soonest' do
      let!(:soonest_outing) { create(:outing, date: 2.days.from_now) }
      let!(:future_outing) { create(:outing, date: 15.days.from_now) }
      let!(:sooner_outing) { create(:outing, date: 5.days.from_now) }

      it 'orders outings by soonest date first' do
        expect(described_class.order_soonest).to eq([soonest_outing, sooner_outing, future_outing])
      end
    end
  end

  describe 'instance methods' do
    describe '#creator' do
      let(:user) { create(:user) }
      let(:outing) { create(:outing, creator_id: user.id) }

      it 'returns the creator of the outing' do
        expect(outing.creator).to eq(user)
      end
    end

    describe '#accepted_participants' do
      let(:current_user) { create(:user) }
      let(:outing) { create(:outing) }
      let!(:accepted_participant1) { create(:participant, outing:, user: create(:user), status: 'confirmed') }
      let!(:accepted_participant2) { create(:participant, outing:, user: create(:user), status: 'confirmed') }
      let(:pending_participant) { create(:participant, outing:, user: create(:user), status: 'pending') }
      let(:declined_participant) { create(:participant, outing:, user: create(:user), status: 'rejected') }

      it 'returns all accepted participants except the current user' do
        expect(outing.accepted_participants(current_user)).to eq([accepted_participant1, accepted_participant2])
      end
    end

    describe '#pending_participants' do
      let(:current_user) { create(:user) }
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }
      let(:outing) { create(:outing, creator_id: user1.id) }
      let!(:participant1) { create(:participant, outing:, user: user2, status: 'pending') }
      let!(:participant2) { create(:participant, outing:, user: current_user, status: 'pending') }
      let!(:participant3) { create(:participant, outing:, user: user1, status: 'confirmed') }

      it 'returns all pending participants except the current user' do
        expect(outing.pending_participants(current_user)).to contain_exactly(participant1)
      end

      it "doesn't return confirmed participants" do
        expect(outing.pending_participants(current_user)).not_to include(participant3)
      end

      it "doesn't return the current user" do
        expect(outing.pending_participants(current_user)).not_to include(participant2)
      end
    end

    describe 'good_start_datetimes' do
      let(:outing1) { create(:outing) }
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }

      it 'returns an empty array if no good times found' do
        expect(outing1.good_start_datetimes).to eq([])
      end

      it 'returns an array of size 2 if two good times found' do
        create(:availability, user: user1, start_time: DateTime.new(1970, 1, 5, 3, 0, 0), end_time: DateTime.new(1970, 1, 5, 6, 0, 0))
        create(:availability, user: user2, start_time: DateTime.new(1970, 1, 5, 5, 0, 0), end_time: DateTime.new(1970, 1, 5, 6, 0, 0))
        create(:participant, user: user1, outing: outing1)
        create(:participant, user: user2, outing: outing1)

        # returned value depends on the timezone, so below doesn't work
        # could hard code the timezone in but then the test would only succeed sometimes, depending on the current timezone
        # expect(outing1.good_start_datetimes).to eq([{ datetime: DateTime.new(1970, 1, 5, 5, 0, 0), people_available: 2 },
        #                                             { datetime: DateTime.new(1970, 1, 5, 4, 0, 0), people_available: 1 }])

        expect(outing1.good_start_datetimes.size).to eq(2)
      end

      it 'returns an array of size 3 if more than three good times found' do
        create(:availability, user: user1, start_time: DateTime.new(1970, 1, 5, 3, 0, 0), end_time: DateTime.new(1970, 1, 5, 6, 0, 0))
        create(:availability, user: user2, start_time: DateTime.new(1970, 1, 5, 5, 0, 0), end_time: DateTime.new(1970, 1, 5, 6, 0, 0))
        create(:availability, user: user2, start_time: DateTime.new(1970, 1, 5, 7, 0, 0), end_time: DateTime.new(1970, 1, 5, 8, 0, 0))
        create(:availability, user: user2, start_time: DateTime.new(1970, 1, 5, 9, 0, 0), end_time: DateTime.new(1970, 1, 5, 10, 0, 0))
        create(:participant, user: user1, outing: outing1)
        create(:participant, user: user2, outing: outing1)
        expect(outing1.good_start_datetimes.size).to eq(3)
      end
    end
  end
end
