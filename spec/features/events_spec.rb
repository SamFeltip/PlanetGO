require 'rails_helper'
require 'faker'

RSpec.describe 'Events' do

  let!(:event_creator) { create(:user, role: User.roles[:advertiser]) }
  let!(:other_event_creator) { create(:user, full_name: 'Sam Sanderson', role: User.roles[:advertiser]) }
  let!(:admin) { create(:user, full_name: 'David Richards', role: User.roles[:admin]) }





  # Submit my event
  context 'when logged in as an advertiser' do

    event_name = 'Reading group'

    event_date = '15/03/2023 17:00'
    event_desc = 'a fun event!'
    event_category = 'bar'

    before :each do
      login_as event_creator
      visit events_url
    end


    context 'I can submit my event' do

      before do
        click_link 'New Event'

        # the user clicks on the button "New Outing"
        # the user fills in a name, a date, a description, and selects "open" as the outing type

        fill_in 'Event Name', with: event_name

        fill_in 'Time and Date', with: event_date

        fill_in 'Description', with: event_desc
        select event_category, from: 'Category'

        # the user clicks the "save" button
        click_button 'Save'
      end

      specify 'saves an event' do
        # expect the program to create an outing object with the above information, and with a creator_id of the logged in user's user_id
        expect(Event.last).to have_attributes(
          name: event_name,
          time_of_event: Time.parse(event_date),
          description: event_desc,
          user_id: event_creator.id)
      end

      specify 'alerts the user the event is under review' do
        # show a notice saying the outing was created
        expect(page).to have_content('Event was created and is under review.')
      end

      specify 'redirects the user to events index' do
        # redirect to the outings index page
        expect(page).to have_current_path(events_path)
      end

      context 'should not show the event in list of events for the current user' do

        context 'if there are no other events' do
          specify 'pending_events card should not exist' do
            page.should have_no_css('#pending_events')
          end
        end

        # context "if there are pending events from others" do
        #
        #   specify "event should not be in pending events card" do
        #     create(:event, user_id: @admin.id)
        #     visit events_path
        #
        #     within "#pending_events" do
        #       expect(page).to have_no_content(event_name)
        #     end
        #   end
        # end



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

    context 'I can remove my event' do
      let!(:event) { create(:event, name: 'an event created by me', user_id: event_creator.id) }
      let!(:other_event) { create(:event, name: 'an event created by someone else', user_id: other_event_creator.id) }

      before do
        visit edit_event_path(event)
        page.find('#destroy_event').click
      end

      specify 'should bring the user to the event show page' do
        expect(page).to have_current_path '/events'
      end

      specify 'should no longer show the outing' do
        # Expect the outing to be deleted and not be on the page anymore
        expect(page).not_to have_content(event.name)
      end

      specify 'should alert the user the outing was deleted' do
        expect(page).to have_content('Event was successfully destroyed.')
      end

      context 'when visiting an event created by another user' do
        before do
          visit edit_event_path(other_event)
        end

        specify 'should not let the user delete this event' do
          expect(page).to_not have_css('#destroy_event')
        end
      end
    end

  end

  context 'when logged in as an admin' do

    before :each do

      @other_event = create(:event, name: 'an event created by someone else', user_id: other_event_creator.id)
      @event3 = create(:event, name: 'this is a third event', user_id: event_creator.id)

      login_as admin
      visit events_path

    end

    specify 'should show pending events in the pending events element' do
      within '#pending_events' do
        expect(page).to have_content(@other_event.name)
      end
    end

    context 'when an admin click the thumbs up button' do

      before do

        within '#pending_events' do
          within "#event_#{@other_event.id}" do
            page.find('.approve_event').click
          end
        end
      end

      specify 'event becomes approved' do
        @other_event = Event.find(@other_event.id)
        expect(@other_event.approved).to be_truthy
      end

      specify 'should no longer show event in pending events' do
        within '#pending_events' do
          expect(page).to have_no_content(@other_event.name)
        end
      end

      specify 'should still show other events in pending events' do
        within '#pending_events' do
          expect(page).to have_content(@event3.name)
        end

      end

      specify 'should show approved event in list of events' do
        within '#events' do
          expect(page).to have_content(@other_event.name)
        end
      end

    end

    context 'when an admin clicks the disapprove button' do

      before do

        within '#pending_events' do
          within "#event_#{@other_event.id}" do
            page.find('.disapprove_event').click
          end
        end
      end

      specify 'event becomes disapproved' do
        @other_event = Event.find(@other_event.id)
        expect(@other_event.approved).to be_falsey
      end

      specify 'should change the disapprove button to a highlighted state' do
        within '#pending_events' do
          within ".event#event_#{@other_event.id}" do
            expect(page).to have_css('.disapprove_event.btn-danger')
            expect(page).to have_no_css('.disapprove_event.btn-outline-danger')
          end
        end
      end

    end

    context 'when I revoke approval of events' do

      before do
        @event3 = create(:event, name: 'this is a third event', user_id: event_creator.id, approved: true)

        # visit event
        visit event_path(@event3)

        # go to settings
        page.find('#event_settings').click

        # disapprove the event
        find(:css, '#event_approved').set(false)

        # save changes
        click_button 'Save'
      end

      specify 'should redirect user to particular event path' do
        expect(page).to have_current_path(event_path(@event3))
      end

      context 'when I visit the events page' do
        before do
          visit events_path
        end

        specify 'should not show the event in the events list' do
          within '#events' do
            expect(page).to have_no_content(@event3.name)
          end
        end

        specify 'should show the event in pending events' do
          within '#pending_events' do
            expect(page).to have_content(@event3.name)
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
            within "#event_#{@event3.id}" do
              expect(page).to have_content(@event3.name)
            end
          end
        end

        specify 'event status icon should be a cross' do
          @event3 = Event.find(@event3.id)
          expect(@event3.approved_icon).to eq('bi-x')
        end
      end
    end
  end
end