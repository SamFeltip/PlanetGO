# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Friends' do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user, full_name: 'Taylor Thompson') }
  let!(:other_user) { create(:user) }

  describe 'Index page' do
    context 'when user is logged in' do
      before { login_as(user) }

      context 'when user has friends' do
        before do
          user.send_follow_request_to(friend)
          friend.accept_follow_request_of(user)
          visit friends_path
        end

        it 'displays list of friends' do
          expect(page).to have_text(friend.full_name)
        end
      end

      context 'when user has no friends' do
        before { visit friends_path }

        it 'displays message indicating no friends' do
          expect(page).to have_content('You have no friends yet.')
        end
      end

      context 'when user clicks the Unfriend button' do
        before do
          user.send_follow_request_to(friend)
          friend.accept_follow_request_of(user)
          visit friends_path
          click_button 'Unfriend'
        end

        it 'removes the friend' do
          expect(page).to have_content('You have no friends yet.')
          expect(user.following?(friend)).to be false
          expect(friend.following?(user)).to be false
        end
      end
    end

    context 'when user is not logged in' do
      before { visit friends_path }

      it 'prompt to log in' do
        expect(page).to have_content('You are not authorized to access this page.')
      end
    end
  end

  describe 'Search page' do
    context 'when user is logged in' do
      before { login_as(user) }

      context 'when user searches for a friend' do
        before do
          visit friend_search_path
          fill_in 'search[name]', with: 'Taylor'
          click_button 'Search'
        end

        it 'displays list of users matching search query' do
          expect(page).to have_text(friend.full_name)
        end
      end

      context 'when there are no results for a given search' do
        before do
          visit friend_search_path
          fill_in 'search[name]', with: 'Megan'
          click_button 'Search'
        end

        it 'displays the no search results message' do
          expect(page).to have_text("Sorry, we couldn't find any users matching the name 'Megan'. Please try a different search term.")
        end
      end

      context 'when user clicks the Add friend button' do
        before do
          visit friend_search_path
          fill_in 'search[name]', with: 'Taylor'
          click_button 'Search'
          click_button 'Add friend'
        end

        it 'sends the friend request' do
          expect(user.sent_follow_request_to?(friend)).to be true
          expect(user.sent_follow_request_to?(other_user)).to be false
        end

        it "changes the button to 'Cancel friend request'" do
          fill_in 'search[name]', with: 'Taylor'
          click_button 'Search'
          expect(page).to have_button('Cancel friend request')
        end
      end

      context 'when user clicks the Cancel friend request button' do
        before do
          user.send_follow_request_to(friend)
          visit friend_search_path
          fill_in 'search[name]', with: 'Taylor'
          click_button 'Search'
          click_button 'Cancel friend request'
        end

        it 'cancels the friend request' do
          expect(user.sent_follow_request_to?(friend)).to be false
        end
      end
    end

    context 'when user is not logged in' do
      before { visit friend_search_path }

      it 'shows authorization error' do
        expect(page).to have_content('You are not authorized to access this page.')
      end
    end
  end

  describe 'Requests page' do
    context 'when user is logged in' do
      before { login_as(user) }

      context 'when user has pending requests' do
        before do
          friend.send_follow_request_to(user)
          visit friend_requests_path
        end

        it 'displays list of pending requests' do
          expect(page).to have_content(friend.full_name)
        end
      end

      context 'when user has no pending requests' do
        before { visit friend_requests_path }

        it 'displays message indicating no requests' do
          expect(page).to have_content('You have no pending friend requests.')
        end
      end

      context 'when user clicks the Accept button' do
        before do
          friend.send_follow_request_to(user)
          visit friend_requests_path
          click_button 'Accept'
          visit friends_path
        end

        it 'accepts the friend request' do
          expect(page).to have_content(friend.full_name)
          expect(user.following?(friend)).to be true
          expect(friend.following?(user)).to be true
        end
      end

      context 'when user clicks the Decline button' do
        before do
          friend.send_follow_request_to(user)
          visit friend_requests_path
          click_button 'Decline'
        end

        it 'declines the friend request' do
          expect(page).not_to have_content(friend.full_name)
          expect(friend.sent_follow_request_to?(user)).to be false
          expect(user.following?(friend)).to be false
          expect(friend.following?(user)).to be false
        end
      end
    end

    context 'when user is not logged in' do
      before { visit friend_requests_path }

      it 'shows authorization error' do
        expect(page).to have_content('You are not authorized to access this page.')
      end
    end
  end
end
