# frozen_string_literal: true

require 'rails_helper'

shared_context 'when using a non-suspended account', type: :request do |user_role|
  let!(:current_user) { create(:user, role: user_role) }
  before do
    create(:event, description: 'CurrentUser', user_id: current_user.id)
  end

  context 'when I am logged in as a non-suspended account and on the events page' do
    before do
      login_as current_user
      visit '/events'
    end

    let!(:event_content) { find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "CurrentUser")]') }

    specify 'I can delete my event' do
      within(event_content) do
        click_on 'Destroy'
      end
      expect(page).not_to have_content 'CurrentUser'
    end

    specify 'I can edit my event' do
      within(event_content) { click_on 'Edit' }
      fill_in 'Description', with: 'CurrentUser Edited'
      click_on 'Save'
      expect(page).to have_content 'CurrentUser Edited'
    end

    specify 'I can show my event' do
      within(event_content) { click_on 'Show' }
      expect(page).to have_content 'Event details'
    end

    specify 'I can create a new event' do
      click_on 'New Event'
      fill_in 'Description', with: 'Event 3'
      click_on 'Save'
      expect(page).to have_content 'Event 3'
    end
  end
end

shared_context 'when using a suspended account', type: :request do |user_role|
  let!(:current_user) { create(:user, role: user_role, suspended: true) }

  let!(:event) { create(:event, description: 'CurrentUser', user_id: current_user.id) }

  context 'when I am logged in as a suspended user and on the events page' do
    before do
      login_as current_user
      visit '/events'
    end

    let!(:event_content) { find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "CurrentUser")]') }

    specify 'I can see my event' do
      expect(page).to have_content 'CurrentUser'
    end

    specify 'I can Show my event' do
      within(event_content) { click_on 'Show' }
      expect(page).to have_content 'Event details'
    end

    specify 'I cannot see the option to edit my event' do
      expect(event_content).not_to have_button 'Edit'
    end

    specify 'I cannot see the option to create an event' do
      expect(page).not_to have_button 'New Event'
    end

    specify 'I cannot Edit my event' do
      visit edit_event_path(event)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'I cannot create a new event' do
      visit new_event_path
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'I cannot Destroy my event' do
      expect do
        login_as current_user
        delete event_path(event)
      end.not_to change(Event, :count)
    end
  end
end

RSpec.describe 'Events' do
  context 'when there are users in the system', type: :request do
    let!(:admin1) { create(:user, email: 'admin1@admin.com', role: 'admin') }
    let!(:user1) { create(:user, email: 'user1@user.com') }
    let!(:user2) { create(:user, email: 'user2@user.com', suspended: true) }
    let!(:advertiser1) { create(:user, role: 'advertiser') }

    context 'when there are events in the system' do
      before do
        create(:event, description: 'User1 Event', user_id: user1.id)
        create(:event, description: 'Advertiser1 Event', user_id: advertiser1.id)
        create(:event, description: 'User2 Event', user_id: user2.id)
      end

      context 'when I am logged in as an admin and on the events page' do
        before do
          login_as admin1
          visit '/events'
        end

        let!(:event_content) { find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "User1 Event")]') }

        specify 'I can see all the events in the system' do
          expect(page).to have_content 'User1 Event' and have_content 'User2 Event'
        end

        specify 'I can delete an event' do
          within(event_content) do
            click_on 'Destroy'
          end
          expect(page).not_to have_content 'User1 Event'
        end

        specify 'I can show an event' do
          within(event_content) do
            click_on 'Show'
          end
          expect(page).to have_content 'Event details'
        end

        specify 'I can edit an event' do
          within(event_content) { click_on 'Edit' }
          fill_in 'Description', with: 'User1 Event Edited'
          click_on 'Save'
          expect(page).to have_content 'User1 Event Edited'
        end
      end
    end
  end

  context 'when I am logged in with a non-suspended commercial account' do
    it_behaves_like 'when using a non-suspended account', 'user'
    it_behaves_like 'when using a non-suspended account', 'advertiser'
  end

  context 'when I am logged in as a suspended commercial account' do
    it_behaves_like 'when using a suspended account', 'user'
    it_behaves_like 'when using a suspended account', 'advertiser'
  end
end
