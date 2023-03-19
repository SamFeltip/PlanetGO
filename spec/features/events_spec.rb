

require 'rails_helper'
require 'faker'

RSpec.describe 'Events' do

  before do
    @event_creator = create(:user, role: User.roles[:advertiser])
    @admin = create(:user, full_name: "David Richards", role: User.roles[:admin])

    @event = create(:event, user_id: @event_creator.id)

  end

  context "params" do
    specify "should understand outing creator" do
      expect(@event_creator.full_name).to eq("John Smith")
    end
  end

  # Submit my event
  context "as an advertiser" do

    event_name = "Reading group"

    event_date = "15/03/2023 17:00"
    event_desc = "a fun event!"
    event_category = "bar"

    before :each do
      login_as @event_creator
      visit events_url
    end


    context "I can submit my event" do

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

      specify "saves an event" do
        # expect the program to create an outing object with the above information, and with a creator_id of the logged in user's user_id
        expect(Event.last).to have_attributes(
          name: event_name,
          time_of_event: Time.parse(event_date),
          description: event_desc,
          user_id: @event_creator.id)
      end

      specify "alerts the user the event is under review" do
        # show a notice saying the outing was created
        expect(page).to have_content('Event was created and is under review.')
      end

      specify "redirects the user to events index" do
        # redirect to the outings index page
        expect(page).to have_current_path(events_path)
      end

      context "should not show the event in list of events for the current user" do

        context "if there are no other events" do
          specify "pending_events card should not exist" do
            page.should have_no_css("#pending_events")
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

      specify "should show the event in list of my pending events" do
        within "#my_pending_events" do
          expect(page).to have_content(event_name)
        end
      end

      specify "should show the event in requested events to publish (for admins)" do
        login_as @admin
        visit "/events"

        within "#pending_events" do
          expect(page).to have_content(event_name)
        end


      end

    end

    context "I can remove my event" do

    end
  end

  context "as an admin" do
    context "I can approve events" do

    end

    context "I can disapprove events" do

    end

    context "I can revoke approval of events" do

    end

  end

end