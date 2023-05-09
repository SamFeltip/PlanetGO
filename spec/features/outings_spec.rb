# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Outings' do
  past_outing_desc = 'this outing was so much fun! thanks for coming guys!'
  past_outing_name = 'past outing'

  let(:other_outing_creator) { create(:user, full_name: 'David Richards') }

  let!(:outing_creator) { create(:user, full_name: 'John Smith') }
  let!(:participant_user) { create(:user, full_name: 'Jane Doe') }
  let!(:participant) { create(:participant, user_id: participant_user.id, outing_id: past_outing.id, status: Participant.statuses[:confirmed]) }

  let!(:past_outing) { create(:outing, name: past_outing_name, creator_id: outing_creator.id, date: 1.week.ago, description: past_outing_desc) }
  let!(:future_outing) { create(:outing, creator_id: outing_creator.id, name: 'future outing', date: 1.week.from_now) }
  let!(:another_outing) { create(:outing, creator_id: other_outing_creator.id, name: 'a better outing!', date: 1.week.from_now) }

  before do
    outing_creator.send_follow_request_to(participant_user)
    participant_user.accept_follow_request_of(outing_creator)
  end

  context 'when setting an outing' do
    it 'records the creators name in the user object' do
      expect(outing_creator.full_name).to eq 'John Smith'
      expect(past_outing.creator).to eq outing_creator
    end
  end

  context 'when a user is logged in as the outing creator' do
    before do
      login_as outing_creator
    end

    describe 'when a user visits their account' do
      before do
        visit '/myaccount'
      end

      it 'shows user their future outings' do
        within '#future_outings' do
          expect(page).to have_content(future_outing.name)
        end
      end

      it 'only shows future outings in the future outings element' do
        within '#future_outings' do
          expect(page).to have_no_content(past_outing.name)
        end
      end

      it 'shows user their past outings' do
        past_outings_element = find_by_id('past_outings')

        expect(past_outings_element).to have_content(past_outing.name)
        expect(past_outings_element).to have_no_content(future_outing.name)
      end
    end

    describe 'when the user creates an outing' do
      outing_name = 'New outing'

      outing_desc = 'a fun outing!'
      outing_type = 'open'

      let!(:friend1) { create(:user) }
      let!(:friend2) { create(:user) }

      before do
        outing_creator.send_follow_request_to(friend1)
        outing_creator.send_follow_request_to(friend2)

        friend2.accept_follow_request_of(outing_creator)
        friend1.accept_follow_request_of(outing_creator)

        visit '/outings'
        click_link 'New Outing'

        fill_in 'Name', with: outing_name

        fill_in 'Description', with: outing_desc

        select outing_type, from: 'Outing type'

        # the user clicks the "save" button
        click_button 'Continue'
      end

      it 'saves an outing' do
        # expect the program to create an outing object with the above information, and with a creator_id of the logged in user's user_id
        expect(Outing.last).to have_attributes(
          name: outing_name,
          description: outing_desc,
          creator_id: outing_creator.id
        )
      end

      it 'creates a participant' do
        # expect the program to create a participant with current_user and new outing present, and the status set to "creator"
        expect(Participant.last).to have_attributes(
          user_id: outing_creator.id,
          outing_id: Outing.last.id,
          status: 'creator'
        )
      end

      it 'alerts the user' do
        # show a notice saying the outing was created
        expect(page).to have_content('Outing was successfully created.')
      end

      it 'redirects the user to outings set_details' do
        # redirect to the outings index page
        expect(page).to have_current_path(set_details_outing_path(Outing.last))
      end

      it 'lets the user see a list of their friends to invite' do
        within '#not_invited_friends' do
          expect(page).to have_content(friend1.full_name)
        end
      end

      it 'lets the user share an outing link' do
        pending 'depends on outing URL'
        expect(page).to have_content('Share this link with your friends')
      end
    end

    context 'when visiting the outings index' do
      before do
        visit outings_url
      end

      context 'when the user inspects an outing' do
        before do
          # Find the "Show" link for the Hoover outing and click it

          within("#outing_#{past_outing.id}") do
            click_link past_outing.name
          end
        end

        # Expect to be on the outing show page and to see the outing's description
        specify 'should bring the user to the outings show page' do
          expect(page).to have_current_path(outing_path(past_outing))
        end

        specify 'should show details of the outing to be visible on the page' do
          expect(page).to have_content(past_outing_desc)
        end
      end

      context 'when a user deletes their own outings' do
        before do
          create(:participant, user_id: outing_creator.id, outing_id: another_outing.id, status: Participant.statuses[:confirmed])
          visit edit_outing_path(past_outing)

          find_by_id('destroy-outing').click
        end

        specify 'should no longer show the outing' do
          # Expect the outing to be deleted and not be on the page anymore
          expect(page).not_to have_content(past_outing_name)
        end

        specify 'should alert the user the outing was deleted' do
          expect(page).to have_content('Outing was successfully destroyed.')
        end

        specify 'doesnt let a user delete someone elses outings' do
          within "#outing_#{another_outing.id}" do
            expect(page).to have_no_content('Destroy')
          end
        end
      end
    end

    context 'when the user wants to manage who is coming to the outing' do
      let!(:user3) { create(:user, full_name: 'Andy Lighthouse') }

      before do
        outing_creator.send_follow_request_to(user3)
        user3.accept_follow_request_of(outing_creator)
        user3.send_follow_request_to(outing_creator)
        outing_creator.accept_follow_request_of(user3)

        login_as outing_creator
        visit set_details_outing_path(past_outing)
      end

      it 'shows a list of participants' do
        # within #participant-cards, expect to see the names of the participants
        within '#participant-cards' do
          expect(page).to have_content(participant.user.full_name)
        end
      end

      it 'shows a list of friends who are not invited' do
        # within #not_invited_friends, expect to see the names of the friends who are not invited
        within '#not_invited_friends' do
          expect(page).to have_content(user3.full_name)
        end
      end

      def click_destroy_participant
        within "#participant_#{participant.id}" do
          accept_confirm do
            find('.destroy-participant').click
          end
          sleep 1
        end
      end

      context 'when you remove participants', js: true do
        it 'removes a participant object' do
          expect { click_destroy_participant }.to change(Participant, :count).by(-1)
        end

        it 'removes the participant from participant cards' do
          click_destroy_participant

          within '#participant-cards' do
            expect(page).to have_no_content(participant_user.full_name)
          end
        end

        it 'adds participant to #not_invited_friends' do
          click_destroy_participant

          within '#not_invited_friends' do
            expect(page).to have_content(participant_user.full_name)
          end
        end
      end

      def press_invite_button
        find_by_id('send-invite-button').click
        sleep 1
      end

      context 'when you invite to a friend', js: true do
        before do
          within "#user_#{user3.id}" do
            check 'user_ids[]'
          end
        end

        it 'adds participant object' do
          expect { press_invite_button }.to change(Participant, :count).by(1)
        end

        it 'adds the participant to participant cards' do
          press_invite_button

          within '#participant-cards' do
            expect(page).to have_content(user3.full_name)
          end
        end

        it 'removes participant from #not_invited_friends' do
          press_invite_button

          within '#not_invited_friends' do
            expect(page).to have_no_content(user3.full_name)
          end
        end
      end
    end

    context 'when the creator manages the proposed events of the outing' do
      let(:event_creator) { create(:user) }
      let(:category1) { create(:category, name: 'Cafe') }
      let(:event1) { create(:event, category: category1, name: "Phil's coffee", user_id: event_creator.id, approved: true, time_of_event: false) }
      let(:event2) { create(:event, category: category1, name: 'Starbucks journey', user_id: event_creator.id, approved: true, time_of_event: '01-02-2023') }
      let!(:event1_react) { create(:event_react, user_id: outing_creator.id, event_id: event1.id) }
      let!(:event2_react) { create(:event_react, user_id: outing_creator.id, event_id: event2.id) }

      let!(:proposed_event) { create(:proposed_event, event_id: event1.id, outing_id: past_outing.id) }

      before do
        visit set_details_outing_path(past_outing, position: 'where')
      end

      specify 'I can search for an event by name or description', js: true do
        within '#event-search-form' do
          fill_in 'description', with: event1.name
          click_on 'search'
        end

        within '#searched-events' do
          expect(page).to have_content(event1.description)
        end
      end

      specify 'I find nothing when I search for something non-existent', js: true do
        within '#event-search-form' do
          fill_in 'description', with: 'Foo bar'
          click_on 'search'
        end

        within '#searched-events' do
          expect(page).to have_content 'No events found'
        end
      end

      specify 'The search form resets if I search for nothing', js: true do
        within '#event-search-form' do
          fill_in 'description', with: ''
          click_on 'search'
          sleep 0.5
        end

        # Div not in visible css as contains nothing
        expect(page).not_to have_css('#searched-events')
      end

      context 'when finished searching for an event', js: true do
        before do
          within '#event-search-form' do
            fill_in 'description', with: event1.name
            click_on 'search'
          end

          within '#searched-events' do
            within "#event_#{event1.id}" do
              find('.send-proposed-event-button').click
              sleep 0.5
            end
          end
        end

        specify 'I can add a searched event to the pending events list', js: true do
          within '#where-timetable' do
            expect(page).to have_content(event1.name) # should be added to events timetable
          end

          within '#searched-events' do
            expect(page).not_to have_content(event1.name) # should be removed from the search results
          end
        end
      end

      it 'shows events the user has liked in the recommended events section that are not proposed' do
        within '#recommended-events' do
          expect(page).to have_content(event2_react.event.name)
        end
      end

      it 'does not show events that are already in the timetable in recommended events' do
        within '#recommended-events' do
          expect(page).to have_no_content(event1_react.event.name)
        end
      end

      context 'when the user adds a proposed event to an outing', js: true do
        def click_add_event(event)
          within '#recommended-events' do
            within "#event_#{event.id}" do
              find('.send-proposed-event-button').click
              sleep 0.5
            end
          end
        end

        before do
          click_add_event(event2)
        end

        it 'adds the event to the timetable', js: true do
          within '#where-timetable' do
            expect(page).to have_content(event2.name)
          end
        end

        it 'removes the event from recommended events', js: true do
          within '#recommended-events' do
            expect(page).to have_no_content(event2.name)
          end
        end
      end

      context 'when the creator removes a proposed event from the outing' do
        def click_remove_event(proposed_event)
          within '#where-timetable' do
            within "#proposed_event_#{proposed_event.id}" do
              accept_confirm do
                click_link 'Remove Event'
              end
              sleep 0.5
            end
          end
        end

        before do
          click_remove_event(proposed_event)
        end

        it 'shows the removed event in recommended events', js: true do
          within '#recommended-events' do
            expect(page).to have_content(event1.name)
          end
        end

        it 'removes the event from the timetable', js: true do
          within '#where-timetable' do
            expect(page).to have_no_content(event1.name)
          end
        end
      end

      context 'when the user selects a new time of a proposed event' do
        before do
          visit outing_path(past_outing)

          within '#where-timetable' do
            # click on the modal button of a proposed_event
            within "#proposed_event_#{proposed_event.id}" do
              find_by_id("modal_button_proposed_event_#{proposed_event.id}").click
            end
          end

          within "#modal_proposed_event_#{proposed_event.id}" do
            # set the time of the proposed event
            find_by_id('proposed_event_proposed_datetime').set('12:00')
            click_button 'Update'
          end
        end

        it 'changes the proposed_datetime of the proposed_event' do
          expect(proposed_event.reload.proposed_datetime.strftime('%H:%M')).to eq('12:00')
        end

        it 'updates the event time in the view', js: true do
          within '#where-timetable' do
            # click on the modal button of a proposed_event
            within "#proposed_event_#{proposed_event.id}" do
              expect(page).to have_content('12:00')
            end
          end
        end
      end

      context 'when the event attached to the proposed event has a set time' do
        let!(:proposed_event2) { create(:proposed_event, event_id: event2.id, outing_id: past_outing.id) }

        before do
          visit outing_path(past_outing)
        end

        it 'does not let the user change the time of the proposed event' do
          within "#modal_proposed_event_#{proposed_event2.id}" do
            # set the time of the proposed event
            # expect proposed_event_proposed_datetime to be disabled
            expect(page).to have_css('#proposed_event_proposed_datetime[disabled]')
          end
        end

        it 'alerts the user the time cannot be changed' do
          within "#modal_proposed_event_#{proposed_event2.id}" do
            expect(page).to have_content('This event has a set date and time.')
          end
        end
      end
    end

    context 'when voting on proposed events' do
      let(:event_creator) { create(:user) }
      let(:category1) { create(:category, name: 'Cafe') }
      let(:event1) { create(:event, category: category1, name: "Phil's coffee", user_id: event_creator.id, approved: true, time_of_event: false) }
      let(:event2) { create(:event, category: category1, name: 'Starbucks journey', user_id: event_creator.id, approved: true, time_of_event: '01-02-2023') }

      let!(:proposed_event) { create(:proposed_event, event_id: event1.id, outing_id: past_outing.id) }

      before do
        visit outing_path(past_outing)
      end

      context 'when liking a proposed events' do
        before do
          within "#proposed_event_#{proposed_event.id}" do
            find_by_id('vote-button').click
          end
        end

        it 'updates the count of likes', js: true do
          within "#proposed_event_#{proposed_event.id}" do
            expect(page).to have_content('1 like')
          end
        end

        it 'updates the count of likes in the modal', js: true do
          find_by_id("modal_button_proposed_event_#{proposed_event.id}").click

          within "#modal_proposed_event_#{proposed_event.id}" do
            within '.proposed-event-votes' do
              expect(page).to have_content(outing_creator.full_name)
            end
          end
        end

        it 'changes the like icon to a filled thumbs up', js: true do
          within "#proposed_event_#{proposed_event.id}" do
            expect(page).to have_css('.bi-hand-thumbs-up-fill')
          end
        end
      end

      it 'lets the user unlike a proposed events' do
        # expect clicking vote-button to increase the count of likes

        within "#proposed_event_#{proposed_event.id}" do
          find_by_id('vote-button').click
          find_by_id('vote-button').click
        end

        expect(page).to have_content('0 likes')
      end
    end

    context 'when the creator stops the voting count' do
      let(:event_creator) { create(:user) }
      let(:category1) { create(:category, name: 'Cafe') }
      let(:event1) { create(:event, category: category1, name: "Phil's coffee", user_id: event_creator.id, approved: true, time_of_event: false) }
      let(:event2) { create(:event, category: category1, name: 'Starbucks journey', user_id: event_creator.id, approved: true, time_of_event: '01-02-2023') }

      let!(:user3) { create(:user, full_name: 'James Thompson') }
      let!(:participant3) { create(:participant, user_id: user3.id, outing_id: past_outing.id) }

      let!(:proposed_event) { create(:proposed_event, event_id: event1.id, outing_id: past_outing.id) }
      let!(:proposed_event2) { create(:proposed_event, event_id: event2.id, outing_id: past_outing.id) }

      before do
        proposed_event.liked_by(outing_creator)
        proposed_event.liked_by(participant_user)
        proposed_event.liked_by(participant3.user)

        proposed_event2.liked_by(outing_creator)

        visit outing_path(past_outing)
      end

      context 'when the creator stops the voting count' do
        before do
          find_by_id('send-invite-button').click
        end

        it 'removes events with less than 50% of the votes' do
          expect(page).to have_no_content(event2.name)
        end

        it 'keeps events with more than 50% of the votes' do
          expect(page).to have_content(event1.name)
        end

        it 'notifies the user the events have been removed' do
          expect(page).to have_content('failed proposed events were deleted.')
        end
      end
    end
  end

  context 'when a user is logged in as a participant' do
    let(:event_creator) { create(:user) }
    let(:category1) { create(:category, name: 'Cafe') }
    let(:event1) { create(:event, category: category1, name: "Phil's coffee", user_id: event_creator.id, approved: true, time_of_event: false) }

    let!(:proposed_event) { create(:proposed_event, event_id: event1.id, outing_id: past_outing.id) }

    before do
      login_as participant_user
    end

    specify 'the user can see the outing' do
      visit outing_path(past_outing)
      expect(page).to have_content(past_outing.name)
    end

    specify 'the user can see the outing proposed events' do
      visit outing_path(past_outing)
      within '#where-timetable' do
        expect(page).to have_content(proposed_event.event.name)
      end
    end

    context 'when the user tries to visit set_details' do
      before do
        visit set_details_outing_path(past_outing)
      end

      it 'redirects to the root page' do
        pending 'ability is not working'
        expect(page).to have_current_path('/')
      end

      it 'alerts the user they are not authorized to access this page' do
        pending 'ability is not working'
        expect(page).to have_content('You are not authorized to access this page.')
      end
    end

    specify 'the user cannot stop the vote count' do
      visit outing_path(past_outing)
      within '#where-timetable' do
        expect(page).to have_no_content('Stop the count!')
      end
    end
  end

  context 'when a user is logged in as an uninvited user' do
    let(:uninvited_user) { create(:user) }

    before do
      login_as uninvited_user
    end

    context 'when they visit a public outing they are not invited to' do
      it 'creates a participant for them' do
        pending('waiting for links to be implemented')
        expect(Participant.where(outing: past_outing, user: uninvited_user).count).to eq(1)
      end
    end

    describe 'the user navigates to an invite link' do
      before do
        visit new_participant_path(another_outing)
      end

      it 'adds the user as a participant' do
        expect(Participant.last).to have_attributes(
          user_id: uninvited_user.id,
          outing_id: another_outing.id,
          status: 'pending'
        )
      end
    end
  end

  context 'when the user is not logged in' do
    describe 'when the user joins by a link' do
      before do
        visit outing_path(past_outing)
      end

      # redirects to log in page
      it 'redirects to the new user registration page' do
        expect(page).to have_current_path('/users/sign_in')
      end

      it 'shows a notice' do
        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
    end
  end
end
