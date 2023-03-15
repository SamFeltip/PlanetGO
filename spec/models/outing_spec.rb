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
#  creator_id       :bigint           not null
#
# Indexes
#
#  index_outings_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
require 'rails_helper'

RSpec.describe Outing, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  context 'past/future' do
    before :each do

      @creator_user = create(:user, email: 'testemail@email.com')

      @past_outing_1 = create(
        :outing,
        name: "past outing 1",
        creator_id: @creator_user.id,
        date: Time.now - 1.day
      )

      @past_outing_2 = create(
        :outing,
        name: "past outing 2",
        creator_id: @creator_user.id,
        date: Time.now - 1.week
      )

      @future_outing_1 = create(
        :outing,
        name: "future outing 1",
        creator_id: @creator_user.id,
        date: Time.now + 1.day
      )

      @future_outing_2 = create(
        :outing,
        name: "future outing 2",
        creator_id: @creator_user.id,
        date: Time.now + 1.week
      )

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
