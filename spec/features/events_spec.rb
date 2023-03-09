# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events' do
  context 'when there are users in the system', type: :request do
    let!(:admin1) { FactoryBot.create(:user, email: 'admin1@admin.com', role: 'admin') }
    let!(:user1) { FactoryBot.create(:user, email: 'user1@user.com') }
    let!(:user2) { FactoryBot.create(:user, email: 'user2@user.com', suspended: true) }

    context 'when there are events in the system' do
      before do
        FactoryBot.create(:event, description: 'User1 Event', user_id: user1.id)
      end

      let!(:event2) { FactoryBot.create(:event, description: 'User2 Event', user_id: user2.id) }

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

      context 'when I am logged in as a non-suspended user and on the events page' do
        before do
          login_as user1
          visit '/events'
        end

        let!(:event_content) { find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "User1 Event")]') }

        specify 'I can delete my event' do
          within(event_content) do
            click_on 'Destroy'
          end
          expect(page).not_to have_content 'User1 Event'
        end

        specify 'I can edit my event' do
          within(event_content) { click_on 'Edit' }
          fill_in 'Description', with: 'User1 Event Edited'
          click_on 'Save'
          expect(page).to have_content 'User1 Event Edited'
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

      context 'when I am logged in as a suspended user and on the events page' do
        before do
          login_as user2
          visit '/events'
        end

        let!(:event_content) { find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "User2 Event")]') }

        specify 'I can see my event' do
          expect(page).to have_content 'User2 Event'
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
          visit edit_event_path(event2)
          expect(page).to have_content 'You are not authorized to access this page.'
        end

        specify 'I cannot create a new event' do
          visit new_event_path
          expect(page).to have_content 'You are not authorized to access this page.'
        end

        specify 'I cannot Destroy my event' do
          expect do
            login_as user2
            delete event_path(event2)
          end.not_to change(Event, :count)
        end
      end
    end
  end
end
