# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event do
  let(:event_creator) { create(:user) }
  let!(:my_event) { create(:event, user_id: event_creator.id) }
  let(:other_user) { create(:user) }
  let(:third_user) { create(:user) }

  describe '#likes' do
    context 'when there are no likes' do
      it 'returns 0 likes' do
        expect(my_event.decorate.likes(other_user)).to eq('0 likes')
      end
    end

    context 'when the current_user has liked' do
      before do
        create(:event_react, event_id: my_event.id, user: event_creator)
      end

      context 'when the user is the only user who has liked the event' do
        it 'returns me and 0 others' do
          expect(my_event.decorate.likes(event_creator, current_user_liked: true)).to eq('liked by you and 0 others')
        end
      end

      context 'when there is 1 other user who has liked' do
        before do
          create(:event_react, event_id: my_event.id, user: other_user)
        end

        it 'returns me and 1 other' do
          expect(my_event.decorate.likes(event_creator, current_user_liked: true)).to eq('liked by you and 1 other')
        end
      end

      context 'when there are many other uses who have liked' do
        before do
          create(:event_react, event_id: my_event.id, user: other_user)
          create(:event_react, event_id: my_event.id, user: third_user)
        end

        it 'returns me and 2 others' do
          expect(my_event.decorate.likes(event_creator, current_user_liked: true)).to eq('liked by you and 2 others')
        end
      end
    end

    context 'when current user hasnt liked' do
      let(:forth_user) { create(:user) }

      before do
        create(:event_react, event_id: my_event.id, user: other_user)
        create(:event_react, event_id: my_event.id, user: third_user)
      end

      context 'when no friends have liked' do
        it 'returns num of likes' do
          expect(my_event.decorate.likes(event_creator, current_user_liked: false)).to eq('2 likes')
        end
      end

      context 'when friends have liked' do
        before do
          event_creator.send_follow_request_to(other_user)
          other_user.accept_follow_request_of(event_creator)

          third_user.accept_follow_request_of(event_creator)
          event_creator.send_follow_request_to(third_user)

          forth_user.accept_follow_request_of(event_creator)
          event_creator.send_follow_request_to(forth_user)
        end

        it 'returns a string including a friends name' do
          expect(my_event.decorate.likes(event_creator)).to include(other_user.full_name).or include(third_user.full_name)
        end
      end
    end
  end
end
