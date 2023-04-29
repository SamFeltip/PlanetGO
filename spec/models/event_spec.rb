# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  address_line1 :string
#  address_line2 :string
#  approved      :boolean
#  description   :text
#  latitude      :float
#  longitude     :float
#  name          :string
#  postcode      :string
#  time_of_event :datetime
#  town          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :bigint
#  user_id       :bigint           not null
#
# Indexes
#
#  index_events_on_category_id  (category_id)
#  index_events_on_latitude     (latitude)
#  index_events_on_longitude    (longitude)
#  index_events_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Event do
  let(:event_creator) { create(:user) }
  let(:other_event_creator) { create(:user) }

  let!(:category) { Category.create(name: 'Bar') }
  let!(:category2) { Category.create(name: 'SomethingUnusable') }
  let!(:my_event) { create(:event, user_id: event_creator.id, category_id: category.id) }
  let!(:other_event) { create(:event, user_id: other_event_creator.id, category_id: category2.id, address_line2: 'City Centre') }

  describe '#image_path' do
    it 'returns a path to an image corresponding with the category name' do
      expect(my_event.image_path).to eq 'event_images/bar.png'
    end

    it 'returns a path to the unknown image when no category is available' do
      expect(other_event.image_path).to eq 'event_images/unknown.png'
    end
  end

  describe '#address' do
    it 'returns a formatted string when address_line2 not present' do
      expect(my_event.address).to eq '104 West Street, Sheffield, S1 4EP'
    end

    it 'returns a formatted string when address_line2 present' do
      expect(other_event.address).to eq '104 West Street, City Centre, Sheffield, S1 4EP'
    end
  end

  describe '#my_events' do
    context 'with my events' do
      let!(:my_approved_event) { create(:event, approved: true, user_id: event_creator.id, category_id: category.id) }

      it 'returns all my events' do
        expect(described_class.my_events(event_creator)).to include(my_event) and include(my_approved_event)
      end
    end

    context 'with other events' do
      it 'does not include other peoples events' do
        expect(described_class.my_events(event_creator)).not_to include(other_event)
      end
    end
  end

  describe '#other_users_pending_events' do
    context 'with my events' do
      it 'does not include my pending events' do
        expect(described_class.other_users_pending_events(event_creator)).not_to include(my_event)
      end
    end

    context 'with other events' do
      let!(:other_approved_event) { create(:event, approved: true, user_id: other_event_creator.id, category_id: category.id) }

      it 'returns all other pending events' do
        expect(described_class.other_users_pending_events(event_creator)).to include(other_event)
      end

      it 'does not include approved events' do
        expect(described_class.other_users_pending_events(event_creator)).not_to include(other_approved_event)
      end
    end
  end

  describe '#user_interest' do
    context 'when another user has an associated interest with an event' do
      before do
        interest = CategoryInterest.where(user_id: other_event_creator.id, category_id: my_event.category_id).first
        interest.update(interest: 1) # user is interested
      end

      it 'finds the interest level of a specified user to this event' do
        expect(my_event.user_interest(other_event_creator)).to eq 1
      end
    end
  end
end
