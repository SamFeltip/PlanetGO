# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventDecorator, type: :decorator do
  let(:event) { create(:event) }
  let(:decorated_event) { described_class.new(event) }

  describe '#display_description' do
    context 'when description is shorter than the specified length' do
      it 'returns the entire description' do
        event = create(:event, description: 'This is a short description.')
        decorator = described_class.new(event)
        expect(decorator.display_description(length: 50)).to eq('This is a short description.')
      end
    end

    context 'when description is longer than the specified length' do
      it 'returns the first n words of the description followed by an ellipsis' do
        event = create(:event, description: 'This is a long description that should be truncated.')
        decorator = described_class.new(event)
        expect(decorator.display_description(length: 10)).to eq('This is a...')
      end

      it "doesn't include half words in the truncated description" do
        event = create(:event, description: 'This is a long description that should be truncated.')
        decorator = described_class.new(event)
        expect(decorator.display_description(length: 15)).to eq('This is a long...')
      end
    end
  end

  describe '#approved_desc' do
    context 'when the event is pending approval' do
      let(:event) { create(:event, approved: nil) }

      it 'returns "pending approval"' do
        expect(decorated_event.approved_desc).to eq('pending approval')
      end
    end

    context 'when the event is approved' do
      let(:event) { create(:event, approved: true) }

      it 'returns "approved"' do
        expect(decorated_event.approved_desc).to eq('approved')
      end
    end

    context 'when the event is rejected' do
      let(:event) { create(:event, approved: false) }

      it 'returns "event rejected<br/>Change the details to request re-evalutation"' do
        expect(decorated_event.approved_desc).to eq('event rejected<br/>Change the details to request re-evalutation')
      end
    end
  end

  describe '#display_time' do
    context 'when the time of the event is present' do
      let(:event) { create(:event, time_of_event: DateTime.now) }

      it 'returns the time of the event formatted as "%b %d, %h:%M %p"' do
        expect(decorated_event.display_time).to eq(event.time_of_event.strftime('%b %d, %I:%M %p'))
      end
    end

    context 'when the time of the event is nil' do
      let(:event) { create(:event, time_of_event: nil) }

      it 'returns "any time"' do
        expect(decorated_event.display_time).to eq('any time')
      end
    end
  end

  describe '#approved_icon' do
    context 'when the event is pending approval' do
      let(:event) { create(:event, approved: nil) }

      it 'returns "bi-question-circle"' do
        expect(decorated_event.approved_icon).to eq('bi-question-circle')
      end
    end

    context 'when the event is approved' do
      let(:event) { create(:event, approved: true) }

      it 'returns "bi-check-circle"' do
        expect(decorated_event.approved_icon).to eq('bi-check-circle')
      end
    end

    context 'when the event is rejected' do
      let(:event) { create(:event, approved: false) }

      it 'returns "bi-x"' do
        expect(decorated_event.approved_icon).to eq('bi-x')
      end
    end
  end

  describe '#like_icon' do
    let(:user_likes) { create(:user) }
    let(:user_dislikes) { create(:user) }

    before do
      user_likes.likes event
    end

    it 'returns "bi-star-fill" if current user liked the event' do
      expect(decorated_event.like_icon(user_likes)).to eq('bi-star-fill')
    end

    it 'returns "bi-star" if current user did not like the event' do
      expect(decorated_event.like_icon(user_dislikes)).to eq('bi-star')
    end
  end

  describe '#approved_colour' do
    it 'returns "purple-icon" if the event is not approved' do
      event = create(:event, approved: nil)
      decorated_event = described_class.new(event)
      expect(decorated_event.approved_colour).to eq('purple-icon')
    end

    it 'returns "green" if the event is approved' do
      event = create(:event, approved: true)
      decorated_event = described_class.new(event)
      expect(decorated_event.approved_colour).to eq('green-icon')
    end

    it 'returns "red" if the event is not approved' do
      event = create(:event, approved: false)
      decorated_event = described_class.new(event)
      expect(decorated_event.approved_colour).to eq('red-icon')
    end
  end

  describe '#map_image' do
    it 'returns the correct URL with the event longitude and latitude' do
      event = create(:event)
      decorated_event = described_class.new(event)
      # url is for -1.0, 53.0 because of the default stub
      expected_url = 'https://api.mapbox.com/styles/v1/mapbox/light-v10/static/pin-s+ff0000(-1.4746,53.38131)/-1.4746,53.38131,10,0/300x200@2x?access_token=pk.eyJ1IjoicmFuZGludDI4IiwiYSI6ImNsaDQwN244MDBnYnEzY3Fnazc4NW14d2UifQ.jdlAkOv03e_XS165HrP2Vg'
      expect(decorated_event.map_image).to eq(expected_url)
    end
  end

  describe '#likes' do
    let(:event_creator) { create(:user) }
    let!(:my_event) { create(:event, user_id: event_creator.id) }
    let(:other_user) { create(:user) }
    let(:third_user) { create(:user) }

    context 'when there are no likes' do
      it 'returns 0 likes' do
        expect(my_event.decorate.likes(current_user: other_user)).to eq('0 likes')
      end
    end

    context 'when the current_user has liked' do
      before do
        my_event.liked_by event_creator
      end

      context 'when the user is the only user who has liked the event' do
        it 'returns me and 0 others' do
          expect(my_event.decorate.likes(current_user: event_creator)).to eq('liked by you and 0 others')
        end
      end

      context 'when there is 1 other user who has liked' do
        before do
          my_event.liked_by other_user
        end

        it 'returns me and 1 other' do
          expect(my_event.decorate.likes(current_user: event_creator)).to eq('liked by you and 1 other')
        end
      end

      context 'when there are many other uses who have liked' do
        before do
          my_event.liked_by other_user
          my_event.liked_by third_user
        end

        it 'returns me and 2 others' do
          expect(my_event.decorate.likes(current_user: event_creator)).to eq('liked by you and 2 others')
        end
      end
    end

    context 'when current user hasnt liked' do
      let(:forth_user) { create(:user) }

      before do
        my_event.liked_by other_user
        my_event.liked_by third_user
        my_event.unliked_by event_creator
      end

      context 'when no friends have liked' do
        it 'returns num of likes' do
          expect(my_event.decorate.likes(current_user: event_creator)).to eq('2 likes')
        end
      end

      context 'when friends have liked' do
        before do
          event_creator.send_follow_request_to(other_user)
          other_user.accept_follow_request_of(event_creator)

          event_creator.send_follow_request_to(third_user)
          third_user.accept_follow_request_of(event_creator)

          event_creator.send_follow_request_to(forth_user)
          forth_user.accept_follow_request_of(event_creator)
        end

        it 'returns a string including a friends name' do
          expect(my_event.decorate.likes(current_user: event_creator)).to include(other_user.full_name).or include(third_user.full_name)
        end
      end
    end
  end
end
