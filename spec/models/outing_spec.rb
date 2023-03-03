# == Schema Information
#
# Table name: outings
#
#  id          :bigint           not null, primary key
#  date        :date
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Outing, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe 'when an outing is being created' do
    it 'creates a participant with my user_id' do
    end
    it 'the participant is set as "creator"' do
    end


  end

  describe 'collaborating on an outing availability' do
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
