# == Schema Information
#
# Table name: outings
#
#  id               :bigint           not null, primary key
#  date             :date
#  description      :text
#  invitation_token :bigint
#  name             :string
#  outing_type      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe Outing, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  context 'past/future' do
    before do
      @past_outing_1 = create(
        :outing,
        name: "past outing 1",
        date: Time.now - 1.day
      )

      @past_outing_2 = create(
        :outing,
        name: "past outing 2",
        date: Time.now - 1.week
      )

      @future_outing_1 = create(
        :outing,
        name: "future outing 1",
        date: Time.now + 1.day
      )

      @future_outing_2 = create(
        :outing,
        name: "future outing 2",
        date: Time.now + 1.week
      )

    end

    describe '#future_outings' do
      it 'returns all outings in the future' do
        expect(Outing.future_outings).to include(@future_outing_1)
        expect(Outing.future_outings).to include(@future_outing_2)
      end

      it 'doesnt return outings in the past' do
        expect(Outing.future_outings).not_to include(@past_outing_1)
        expect(Outing.future_outings).not_to include(@past_outing_2)
      end
    end
  end

  context 'when an outing is being created' do
    describe 'creates a participant with my user_id' do
      it 'the participant is set as "creator"' do

      end
    end


  end

  context 'collaborating on an outing availability' do
    # availability:
    #   user_id
    #   start_time
    #   end_time
  end

  context 'when an outing has been created' do
    context 'where multiple participants have accepted and filled in availability' do
      describe 'on button press, participant availability is compared' do

        it 'shows a time which is best for as many people as possible' do

        end

      end
    end
  end

end
