# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events' do
  let!(:category) { Category.create(name: 'Bar') }
  let!(:music_category) { Category.create(name: 'Music') }
  let!(:event_creator) { create(:user, role: User.roles[:advertiser]) }
  let!(:other_event_creator) { create(:user, role: User.roles[:advertiser]) }
  let!(:admin) { create(:user, role: User.roles[:admin]) }
  let!(:user) { create(:user) }

  # Submit my event
  context 'when logged in as an advertiser' do
    event_name = 'Reading group'
    event_address_line1 = '104 West St'
    event_address_line2 = 'City Centre'
    event_town = 'Sheffield'
    event_postcode = 'S1 4EP'

    event_date = '15/03/2023 17:00'
    event_desc = 'a fun event!'
    event_category = 'Bar'

    before do
      login_as event_creator
      visit events_url
    end

    context 'when I submit my event' do
      before do
        click_link 'New Event'

        fill_in 'Event Name', with: event_name
        fill_in 'Address Line 1', with: event_address_line1
        fill_in 'Address Line 2', with: event_address_line2
        fill_in 'Town', with: event_town
        fill_in 'Postcode', with: event_postcode
        fill_in 'Time and Date', with: event_date
        fill_in 'Description', with: event_desc
        select event_category, from: 'Category'

        click_button 'Save'
      end

      specify 'saves an event' do
        expect(Event.last).to have_attributes(
          name: event_name,
          address_line1: event_address_line1,
          address_line2: event_address_line2,
          town: event_town,
          postcode: event_postcode,
          time_of_event: Time.zone.parse(event_date),
          description: event_desc,
          user_id: event_creator.id
        )
      end

      specify 'the event address gets geocoded' do
        expect(Event.last).to have_attributes(
          longitude: -1.0,
          latitude: 53.0
        )
      end

      specify 'alerts the user the event is under review' do
        expect(page).to have_content('Event was created and is under review.')
      end

      specify 'redirects the user to events index' do
        expect(page).to have_current_path(events_path)
      end

      specify 'pending_events card should not exist' do
        expect(page).not_to have_css('#pending_events')
      end

      specify 'should show the event in list of my pending events' do
        within '#my_pending_events' do
          expect(page).to have_content(event_name)
        end
      end

      specify 'should show the event in requested events to publish (for admins)' do
        login_as admin
        visit '/events'

        within '#pending_events' do
          expect(page).to have_content(event_name)
        end
      end
    end

    context 'when I try to submit an event without a name' do
      before do
        click_link 'New Event'

        fill_in 'Address Line 1', with: event_address_line1
        fill_in 'Town', with: event_town
        fill_in 'Postcode', with: event_postcode
        fill_in 'Time and Date', with: event_date
        fill_in 'Description', with: event_desc
        select event_category, from: 'Category'

        click_button 'Save'
      end

      specify do
        expect(page).to have_content "Name can't be blank"
      end
    end

    context 'when I try to submit an event without an address line' do
      before do
        click_link 'New Event'

        fill_in 'Event Name', with: event_name
        fill_in 'Town', with: event_town
        fill_in 'Postcode', with: event_postcode
        fill_in 'Time and Date', with: event_date
        fill_in 'Description', with: event_desc
        select event_category, from: 'Category'

        click_button 'Save'
      end

      specify do
        expect(page).to have_content "Address line1 can't be blank"
      end
    end

    context 'when I try to submit an event without a town' do
      before do
        click_link 'New Event'

        fill_in 'Event Name', with: event_name
        fill_in 'Address Line 1', with: event_address_line1
        fill_in 'Postcode', with: event_postcode
        fill_in 'Time and Date', with: event_date
        fill_in 'Description', with: event_desc
        select event_category, from: 'Category'

        click_button 'Save'
      end

      specify do
        expect(page).to have_content "Town can't be blank"
      end
    end

    context 'when I try to submit an event without a postcode' do
      before do
        click_link 'New Event'

        fill_in 'Event Name', with: event_name
        fill_in 'Address Line 1', with: event_address_line1
        fill_in 'Town', with: event_town
        fill_in 'Time and Date', with: event_date
        fill_in 'Description', with: event_desc
        select event_category, from: 'Category'

        click_button 'Save'
      end

      specify do
        expect(page).to have_content "Postcode can't be blank"
      end
    end

    context 'when I try to submit an event with an invalid postcode' do
      before do
        click_link 'New Event'

        fill_in 'Event Name', with: event_name
        fill_in 'Address Line 1', with: event_address_line1
        fill_in 'Town', with: event_town
        fill_in 'Postcode', with: 'AB CDE'
        fill_in 'Time and Date', with: event_date
        fill_in 'Description', with: event_desc
        select event_category, from: 'Category'

        click_button 'Save'
      end

      specify do
        expect(page).to have_content 'Postcode is invalid'
      end
    end

    context 'when I try to submit an event without a description' do
      before do
        click_link 'New Event'

        fill_in 'Event Name', with: event_name
        fill_in 'Address Line 1', with: event_address_line1
        fill_in 'Town', with: event_town
        fill_in 'Postcode', with: event_postcode
        fill_in 'Time and Date', with: event_date
        select event_category, from: 'Category'

        click_button 'Save'
      end

      specify do
        expect(page).to have_content "Description can't be blank"
      end
    end

    context 'when I try to submit an event without a category' do
      before do
        click_link 'New Event'

        fill_in 'Event Name', with: event_name
        fill_in 'Address Line 1', with: event_address_line1
        fill_in 'Town', with: event_town
        fill_in 'Postcode', with: event_postcode
        fill_in 'Time and Date', with: event_date
        fill_in 'Description', with: event_desc

        click_button 'Save'
      end

      specify do
        expect(page).to have_content "Category can't be blank"
      end
    end

    context 'when I remove my event from the edit event page' do
      let!(:event) { create(:event, name: 'an event created by me', user_id: event_creator.id, category_id: category.id) }
      let!(:other_person_event) { create(:event, name: 'an event created by someone else', user_id: other_event_creator.id, category_id: category.id) }

      before do
        visit edit_event_path(event)
        page.find_by_id('destroy_event').click
      end

      specify 'should bring the user to the event show page' do
        expect(page).to have_current_path '/events'
      end

      specify 'should no longer show the outing' do
        expect(page).not_to have_content(event.name)
      end

      specify 'should alert the user the outing was deleted' do
        expect(page).to have_content('Event was successfully destroyed.')
      end

      context 'when visiting an event created by another user' do
        before do
          visit edit_event_path(other_person_event)
        end

        specify 'should not let the user delete this event' do
          expect(page).not_to have_css('#destroy_event')
        end
      end
    end

    context 'when I remove an event from the events show page' do
      let!(:event) { create(:event, name: 'an event created by me', user_id: event_creator.id, category_id: category.id) }

      before do
        visit events_path
        within '#my_pending_events' do
          within "#event_#{event.id}" do
            page.find('.delete-event').click
          end
        end
      end

      it 'removes the event from the system' do
        expect(Event.find_by(id: event.id)).to be_nil
      end

      it 'alerts the user the event was deleted' do
        expect(page).to have_content('Event was successfully destroyed.')
      end

      it 'removes the event from the page' do
        expect(page).not_to have_css("#event_#{event.id}")
      end
    end
  end

  context 'when logged in as an admin' do
    other_person_event_name = 'an event created by someone else'
    let!(:other_person_event) { create(:event, name: other_person_event_name, user_id: other_event_creator.id, category_id: category.id) }
    let!(:cool_event) { create(:event, name: 'this is a cool event', user_id: event_creator.id, category_id: category.id) }

    before do
      login_as admin
      visit events_path
    end

    specify 'there is no option to edit my interests' do
      expect(page).not_to have_content 'Edit Event Category Interests'
    end

    specify 'there is no option to re-order events by my interests' do
      expect(page).not_to have_content 'Prioritise events according to your interests?'
    end

    specify 'should show pending events in the pending events element' do
      within '#pending_events' do
        expect(page).to have_content(other_person_event.name)
      end
    end

    context 'when an admin click the thumbs up button' do
      before do
        within '#pending_events' do
          within "#event_#{other_person_event.id}" do
            page.find('.approve_event').click
          end
        end
      end

      specify 'event becomes approved' do
        other_person_event = Event.where(name: other_person_event_name).first
        expect(other_person_event.approved).to be_truthy
      end

      specify 'should no longer show event in pending events' do
        within '#pending_events' do
          expect(page).to have_no_content(other_person_event.name)
        end
      end

      specify 'should still show other events in pending events' do
        within '#pending_events' do
          expect(page).to have_content(cool_event.name)
        end
      end

      specify 'should show approved event in list of events' do
        within '#events' do
          expect(page).to have_content(other_person_event.name)
        end
      end
    end

    context 'when an admin clicks the disapprove button' do
      before do
        within '#pending_events' do
          within "#event_#{other_person_event.id}" do
            page.find('.disapprove_event').click
          end
        end
      end

      specify 'event becomes disapproved' do
        other_person_event = Event.where(name: other_person_event_name).first
        expect(other_person_event.approved).to be_falsey
      end

      specify 'should change the disapprove button to a highlighted state' do
        within '#pending_events' do
          within ".event#event_#{other_person_event.id}" do
            expect(page).to have_css('.disapprove_event.btn-danger')
            expect(page).not_to have_css('.disapprove_event.btn-outline-danger')
          end
        end
      end
    end

    context 'when I revoke approval of events' do
      cool_event_name = 'this is a cool event'
      let!(:cool_event) { create(:event, name: cool_event_name, user_id: event_creator.id, approved: true, category_id: category.id) }

      before do
        visit event_path(cool_event)

        page.find_by_id('event_settings').click

        find(:css, '#event_approved').set(false)

        click_button 'Save'
      end

      specify 'should redirect user to particular event path' do
        expect(page).to have_current_path(event_path(cool_event))
      end

      context 'when I visit the events page' do
        before do
          visit events_path
        end

        specify 'should not show the event in the events list' do
          within '#events' do
            expect(page).to have_no_content(cool_event.name)
          end
        end

        specify 'should show the event in pending events' do
          within '#pending_events' do
            expect(page).to have_content(cool_event.name)
          end
        end
      end

      context 'when I log in as the disapproved event and visit the events page' do
        before do
          login_as event_creator
          visit events_path
        end

        specify 'should should show disapproved event in my pending events' do
          within '#my_pending_events' do
            within "#event_#{cool_event.id}" do
              expect(page).to have_content(cool_event.name)
            end
          end
        end

        specify 'event status icon should be a cross' do
          cool_event = Event.where(name: cool_event_name).first
          expect(cool_event.decorate.approved_icon).to eq('bi-x')
        end
      end
    end
  end

  context 'when logged in as a user' do
    let!(:event1) { create(:event, name: 'my great event', user_id: event_creator.id, category_id: category.id, approved: true) }
    let!(:event2) { create(:event, name: 'a different great event', user_id: event_creator.id, category_id: category.id, approved: true) }
    let!(:event3) { create(:event, name: 'a rubbish event', user_id: event_creator.id, category_id: music_category.id, approved: true) }

    before do
      user_list = create_list(:user, 5)
      user_list.each do |react_user|
        create(:event_react, event_id: event2.id, user_id: react_user.id)
      end

      create(:event_react, event_id: event1.id, user_id: admin.id)
      create(:event_react, event_id: event1.id, user_id: other_event_creator.id)

      create(:event_react, event_id: event2.id, user_id: user.id)

      login_as user
      visit events_path
    end

    context 'when on the events page' do
      before do
        visit events_path
      end

      specify 'I can see events in the system' do
        expect(page).to have_content 'my great event'
      end

      specify 'I click on the button to take my to my category interests' do
        click_on 'Edit Event Category Interests'
        expect(page).to have_current_path category_interests_path, ignore_query: true
      end

      specify 'I can search for an event' do
        fill_in 'description', with: 'my great event'
        click_on 'Search'
        expect(page).to have_content 'my great event'
        expect(page).not_to have_content 'a different great event'
        expect(page).not_to have_content 'a rubbish event'
      end

      specify 'I can search by event category' do
        select 'Bar', from: 'category_id'
        click_on 'Search'
        expect(page).to have_content 'my great event'
        expect(page).to have_content 'a different great event'
        expect(page).not_to have_content 'a rubbish event'
      end

      specify 'I can search by event and category' do
        fill_in 'description', with: 'my great event'
        select 'Music', from: 'category_id'
        click_on 'Search'
        expect(page).not_to have_content 'my great event'
        expect(page).not_to have_content 'a different great event'
        expect(page).not_to have_content 'a rubbish event'
      end

      context 'when I have specified an interest in a category' do
        before do
          interest = CategoryInterest.where(user_id: user.id, category_id: music_category.id).first
          interest.update(interest: 1) # user is interested
        end

        specify 'the events belonging to this category are push to the top' do
          click_on 'Search'
          # Expect first item shown on page to be the rubbish music event
          expect(page.find('#events > div:nth-child(1)')).to have_content 'a rubbish event'
        end
      end
    end

    context 'when a user sees a particular event' do
      before do
        visit event_path(event1)
      end

      specify 'should see the number of likes' do
        within '.event_like' do
          expect(page).to have_content('2 likes')
        end
      end

      context 'when a user likes an event' do
        before do
          click_link 'Like this Event'
          # revisit the page (javascript is off)
          visit event_path(event1)
        end

        specify 'should change the contents of the like button' do
          within '.event_like' do
            expect(page).to have_content('liked')
          end
        end

        specify 'should increase the number of likes for the event' do
          # was previously 2
          expect(Event.find(event1.id).likes.count).to eq(3)
        end

        specify 'should create an Event react of the current user' do
          expect(EventReact.last).to have_attributes(
            user_id: user.id,
            event_id: event1.id
          )
        end
      end
    end

    context 'when I visit my accounts page' do
      before do
        login_as user
        visit '/myaccount'
      end

      specify 'should see a list of my liked events' do
        within '#liked_events' do
          expect(page).to have_content(event2.name)
          expect(page).to have_no_content(event3.name)
        end
      end
    end
  end
end
