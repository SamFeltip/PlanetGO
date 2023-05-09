# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  full_name              :string           not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invite_token           :string
#  invited_by_type        :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  latitude               :float
#  locked_at              :datetime
#  longitude              :float
#  postcode               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user")
#  sign_in_count          :integer          default(0), not null
#  suspended              :boolean          default(FALSE)
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_latitude              (latitude)
#  index_users_on_longitude             (longitude)
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User do
  let!(:creator_user) { create(:user, full_name: 'John Smith', email: 'testemail@email.com') }

  let!(:past_outing1) do
    create(
      :outing,
      name: 'past outing 1',
      creator_id: creator_user.id,
      date: 1.day.ago
    )
  end

  let!(:past_outing2) do
    create(
      :outing,
      name: 'past outing 2',
      creator_id: creator_user.id,
      date: 1.week.ago
    )
  end

  let!(:future_outing1) do
    create(
      :outing,
      name: 'future outing 1',
      creator_id: creator_user.id,
      date: 1.day.from_now
    )
  end

  let!(:future_outing2) do
    create(
      :outing,
      name: 'future outing 2',
      creator_id: creator_user.id,
      date: 1.week.from_now
    )
  end

  it 'Returns the name when converted to a string' do
    expect(creator_user.to_s).to eq 'John Smith'
  end

  describe '#add_categories' do
    let!(:category1) { Category.create(name: 'Bar') }
    let!(:user1) { create(:user, role: described_class.roles[:user]) }
    let!(:reporter1) { create(:user, role: described_class.roles[:reporter]) }

    it 'creates a link from commercial users through category interests' do
      expect(user1.categories.find { |c| c == category1 }).not_to be_nil
    end

    it 'does not create a link from non-commercial users through category interests' do
      expect(reporter1.categories.find { |c| c == category1 }).to be_nil
    end
  end

  describe '#commercial' do
    it 'Returns true if the user is of role user or advertiser' do
      user = create(:user, role: described_class.roles[:user])
      expect(user.commercial).to be true
    end

    it 'Returns false if the user is of role admin or reporter' do
      user = create(:user, role: described_class.roles[:reporter])
      expect(user.commercial).to be false
    end
  end

  it 'shows future outings' do
    expect(future_outing1.date).to eq(Time.zone.today + 1.day)
  end

  describe '#get_random_friend' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }

    context 'when user1 has no friends' do
      it 'returns nil' do
        expect(user1.get_random_friend).to be_nil
      end
    end

    context 'when user1 has 2 friends' do
      before do
        user1.send_follow_request_to(user2)
        user2.accept_follow_request_of(user1)

        user1.send_follow_request_to(user3)
        user3.accept_follow_request_of(user1)
      end

      it 'returns a random friend' do
        expect(user1.get_random_friend).to eq(user2).or eq(user3)
      end
    end

    context 'when an event is introduced' do
      let!(:event1) { create(:event, user: creator_user) }

      before do
        create(:event_react, user: user2, event: event1)
      end

      context 'when user1 has no friends' do
        it 'returns nil' do
          expect(user1.get_random_friend(event: event1)).to be_nil
        end
      end

      context 'when user1 has liked the event but they have no friends' do
        before do
          create(:event_react, user: user1, event: event1)
        end

        it 'returns nil' do
          expect(user1.get_random_friend(event: event1)).to be_nil
        end
      end

      context 'when user2 has liked the event and is a friend of user1' do
        before do
          create(:event_react, user: user2, event: event1)
          user1.send_follow_request_to(user2)
          user2.accept_follow_request_of(user1)

          user1.send_follow_request_to(user3)
          user3.accept_follow_request_of(user1)
        end

        it 'returns user2' do
          expect(user1.get_random_friend(event: event1)).to eq(user2)
        end

        it 'does not return another friend who has no liked the event' do
          expect(user1.get_random_friend(event: event1)).not_to eq(user3)
        end
      end

      context 'when many friends have liked the event' do
        before do
          create(:event_react, user: user2, event: event1)
          create(:event_react, user: user3, event: event1)
          user1.send_follow_request_to(user2)
          user2.accept_follow_request_of(user1)
          user1.send_follow_request_to(user3)
          user3.accept_follow_request_of(user1)
        end

        it 'returns user2 or user3' do
          expect(user1.get_random_friend(event: event1)).to eq(user2).or eq(user3)
        end
      end
    end
  end

  describe '#future_outings' do
    it 'returns all outings in the future' do
      expect(creator_user.future_outings).to include(future_outing1)
      expect(creator_user.future_outings).to include(future_outing2)
    end

    it 'doesnt return outings in the past' do
      expect(creator_user.future_outings).not_to include(past_outing1)
      expect(creator_user.future_outings).not_to include(past_outing2)
    end
  end

  describe '#past_outings' do
    it 'doesnt return outings in the future' do
      expect(creator_user.past_outings).not_to include(future_outing1)
      expect(creator_user.past_outings).not_to include(future_outing2)
    end

    it 'returns all outings in the past' do
      expect(creator_user.past_outings).to include(past_outing1)
      expect(creator_user.past_outings).to include(past_outing2)
    end
  end

  describe '#local_events' do
    context 'when postcode present and there are events happening in 10 mile radius' do
      let!(:user) { create(:user, postcode: 'S1 4EP') }
      let!(:creator) { create(:user) }
      let!(:event1) do
        create(:event, address_line1: '104 West Street', town: 'Sheffield', postcode: 'S1 4EP', time_of_event: '2023-02-24',
                       user_id: creator.id, approved: true)
      end
      let!(:event2) do
        create(:event, address_line1: '104 West Street', town: 'Sheffield', postcode: 'S1 4EP', time_of_event: '2023-02-24',
                       user_id: creator.id, approved: true)
      end
      let!(:event3) do
        create(:event, address_line1: '104 West Street', town: 'Sheffield', postcode: 'S1 4EP', time_of_event: '2023-02-24',
                       user_id: creator.id, approved: true)
      end
      let!(:unapproved_event) do
        create(:event, address_line1: '104 West Street', town: 'Sheffield', postcode: 'S1 4EP', time_of_event: '2023-02-24',
                       user_id: creator.id, approved: false)
      end

      it 'returns 3 local events' do
        local_events = user.local_events
        expect(local_events).to include(event1)
        expect(local_events).to include(event2)
        expect(local_events).to include(event3)
      end

      it 'does not return unapproved events' do
        expect(user.local_events).not_to include(unapproved_event)
      end
    end

    context 'when postcode not present' do
      let!(:user) { create(:user, postcode: '') }

      it 'returns no events' do
        expect(user.local_events).to be_nil
      end
    end
  end

  describe '#final_events' do
    let(:event_creator) { create(:user) }

    context 'when the user has a post code' do
      let(:accommodation_category) { create(:category, name: 'accommodation') }
      let(:restaurant_category) { create(:category, name: 'restaurant') }

      let(:user_with_postcode) { create(:user, postcode: 'S1 4EP') }

      let!(:far_away_accommodation) do
        create(
          :event,
          name: 'far_away_accommodation',
          category: accommodation_category,
          postcode: 'NE1 1YF',
          address_line1: '25-27 Mosley St',
          town: 'Newcastle',
          user: event_creator,
          approved: true
        )
      end

      let!(:far_away_restaurant) do
        create(
          :event,
          name: 'far_away_restaurant',
          category: restaurant_category,
          postcode: 'NE1 1YF',
          address_line1: '25-27 Mosley St',
          town: 'Newcastle',
          user: event_creator,
          approved: true
        )
      end

      let!(:unapproved_accommodation) do
        create(
          :event, category: accommodation_category,
                  name: 'unapproved_accommodation',
                  address_line1: '104 West Street',
                  town: 'Sheffield',
                  postcode: 'S1 4EP',
                  time_of_event: '2023-02-24',
                  user: event_creator, approved: false
        )
      end

      context 'when there is accommodation and restaurant nearby' do
        let!(:accommodation) do
          create(
            :event,
            category: accommodation_category,
            name: 'accommodation',
            address_line1: '104 West Street',
            town: 'Sheffield',
            postcode: 'S1 4EP',
            time_of_event: '2023-02-24',
            user: event_creator,
            approved: true
          )
        end

        let!(:restaurant) do
          create(
            :event, name: 'restaurant',
                    category: restaurant_category,
                    address_line1: '104 West Street',
                    town: 'Sheffield',
                    postcode: 'S1 4EP',
                    time_of_event: '2023-02-24',
                    user: event_creator,
                    approved: true
          )
        end

        it 'returns two events' do
          expect(user_with_postcode.final_events.count).to eq(2)
        end

        it 'returns both an accommodation and restaurant' do
          final_events = user_with_postcode.final_events

          expect(final_events.first.category).to eq(accommodation_category)
          expect(final_events.second.category).to eq(restaurant_category)
        end

        it 'returns the closest accommodation and restaurants' do
          final_events = user_with_postcode.final_events

          expect(final_events.first).to eq(accommodation)
          expect(final_events.second).to eq(restaurant)
        end

        it 'does not return unapproved events' do
          expect(user_with_postcode.final_events).not_to include(unapproved_accommodation)
        end

        it 'does not return events far from the users location' do
          final_events = user_with_postcode.final_events
          expect(final_events).not_to include(far_away_accommodation)
          expect(final_events).not_to include(far_away_restaurant)
        end
      end

      context 'when there is accommodation nearby but no restaurant nearby' do
        let!(:accommodation) do
          create(
            :event,
            category: accommodation_category,
            name: 'accommodation',
            address_line1: '104 West Street',
            town: 'Sheffield',
            postcode: 'S1 4EP',
            time_of_event: '2023-02-24',
            latitude: 53.3814,
            longitude: -1.4746,
            user: event_creator,
            approved: true
          )
        end

        it 'returns one event' do
          expect(user_with_postcode.final_events.count).to eq(1)
        end

        it 'returns the nearby accommodation' do
          final_events = user_with_postcode.final_events
          expect(final_events.first).to eq(accommodation)
        end

        it 'returns an accommodation' do
          final_events = user_with_postcode.final_events
          expect(final_events.first.category).to eq(accommodation_category)
        end

        it 'does not return a restaurant' do
          final_events_category_ids = user_with_postcode.final_events.pluck(:category_id)
          expect(final_events_category_ids).not_to include(restaurant_category.id)
        end
      end

      context 'when there is a restaurant nearby but no hotel' do
        let!(:restaurant) do
          create(
            :event, name: 'restaurant',
                    category: restaurant_category,
                    address_line1: '104 West Street',
                    town: 'Sheffield',
                    postcode: 'S1 4EP',
                    time_of_event: '2023-02-24',
                    latitude: 53.38131,
                    longitude: -1.4746,
                    user: event_creator,
                    approved: true
          )
        end

        it 'returns one event' do
          expect(user_with_postcode.final_events.count).to eq(1)
        end

        it 'returns the nearby restaurant' do
          final_events = user_with_postcode.final_events
          expect(final_events.first).to eq(restaurant)
        end

        it 'returns a restaurant' do
          final_events = user_with_postcode.final_events
          expect(final_events.first.category).to eq(restaurant_category)
        end

        it 'doesnt return an accommodation' do
          final_event_category_ids = user_with_postcode.final_events.pluck(:category_id)
          expect(final_event_category_ids).not_to include(accommodation_category.id)
        end
      end

      context 'when there is neither accommodation nor a restaurant nearby' do
        it 'returns an empty list' do
          expect(user_with_postcode.final_events).to eq(Event.none)
        end
      end
    end

    context 'when the user does not have a post code' do
      let(:user_without_postcode) { create(:user, postcode: '') }

      let(:accommodation_category) { create(:category, name: 'accommodation') }
      let(:restaurant_category) { create(:category, name: 'restaurant') }

      context 'when there is no accommodation or restaurants in the system' do
        it 'returns an empty list' do
          expect(user_without_postcode.final_events).to eq(Event.none)
        end
      end

      context 'when there is no accommodation but there are restaurants in the system' do
        let!(:far_away_restaurant) do
          create(
            :event,
            name: 'far_away_restaurant',
            category: restaurant_category,
            postcode: 'NE1 1YF',
            address_line1: '25-27 Mosley St',
            town: 'Newcastle',
            user: event_creator,
            approved: true
          )
        end

        it 'returns the restaurant' do
          final_events = user_without_postcode.final_events
          expect(final_events.first).to eq(far_away_restaurant)
        end
      end

      context 'when there are no restaurants but there is accommodation in the system' do
        let!(:far_away_accommodation) do
          create(
            :event,
            name: 'far_away_accommodation',
            category: accommodation_category,
            postcode: 'NE1 1YF',
            address_line1: '25-27 Mosley St',
            town: 'Newcastle',
            user: event_creator,
            approved: true
          )
        end

        it 'returns the accommodation' do
          final_events = user_without_postcode.final_events
          expect(final_events.first).to eq(far_away_accommodation)
        end
      end

      context 'when there is both accommodation and restaurants in the system' do
        let!(:far_away_accommodation) do
          create(
            :event,
            name: 'far_away_accommodation',
            category: accommodation_category,
            postcode: 'NE1 1YF',
            address_line1: '25-27 Mosley St',
            town: 'Newcastle',
            user: event_creator,
            approved: true
          )
        end

        let!(:far_away_restaurant) do
          create(
            :event,
            name: 'far_away_restaurant',
            category: restaurant_category,
            postcode: 'NE1 1YF',
            address_line1: '25-27 Mosley St',
            town: 'Newcastle',
            user: event_creator,
            approved: true
          )
        end

        it 'returns the restaurant and the accommodation' do
          final_events = user_without_postcode.final_events
          expect(final_events.second).to eq(far_away_restaurant)
          expect(final_events.first).to eq(far_away_accommodation)
        end
      end
    end

    context 'when accommodation and restaurant categories arent in the system' do
      let(:user) { create(:user, postcode: 'S1 2LT') }

      it 'returns nil' do
        expect(user.final_events).to eq(Event.none)
      end
    end
  end
end
