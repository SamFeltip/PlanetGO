# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe 'Outings' do
  past_outing_desc = 'this outing was so much fun! thanks for coming guys!'
  past_outing_name = 'past outing'

  let(:other_outing_creator) { create(:user, full_name: 'David Richards') }

  let!(:outing_creator) { create(:user, full_name: 'John Smith') }
  let!(:past_outing) { create(:outing, name: past_outing_name, creator_id: outing_creator.id, date: 1.week.ago, description: past_outing_desc) }
  let!(:future_outing) { create(:outing, creator_id: outing_creator.id, name: 'future outing', date: 1.week.from_now) }
  let!(:another_outing) { create(:outing, creator_id: other_outing_creator.id, name: 'a better outing!', date: 1.week.from_now) }

  context 'when setting up user' do
    it 'records the creators name in the user object' do
      expect(outing_creator.full_name).to eq 'John Smith'
      expect(past_outing.creator).to eq outing_creator
    end
  end

  context 'when a user is logged in' do
    before do
      login_as outing_creator
    end

    describe 'when a user visit their account' do
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

    describe 'lets the user create an outing' do
      outing_name = 'New outing'

      outing_desc = 'a fun outing!'
      outing_type = 'open'

      before do
        visit '/outings'
        click_link 'New Outing'

        # the user clicks on the button "New Outing"
        # the user fills in a name, a date, a description, and selects "open" as the outing type

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

      it 'lets the user see a list of their friends' do
        pending 'depends on friends list'
        expect(page).to have_content('Select friends to invite')
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
          within "#outing_#{past_outing.id}" do
            click_link 'Show'
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
          visit outings_url

          # Find the "Show" link for the Hoover outing and click it
          within "#outing_#{past_outing.id}" do
            click_link 'Destroy'
          end
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
      let!(:user1) { create(:user) }
      # let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }

      let!(:participant1) { create(:participant, user_id: user1.id, outing_id: past_outing.id) }

      before do
        login_as outing_creator
        visit set_details_outing_path(past_outing)
      end

      it 'shows a list of participants' do
        # within #participant-cards, expect to see the names of the participants
        within '#participant-cards' do
          expect(page).to have_content(user1.full_name)
        end
      end

      it 'shows a list of friends who are not invited' do
        # within #not_invited_friends, expect to see the names of the friends who are not invited
        within '#not_invited_friends' do
          expect(page).to have_content(user3.full_name)
        end
      end

      context 'when you remove participants', js: true do
        it 'removes a participant object' do
          pending 'waiting on javascript fix'
          within "#participant_#{participant1.id}" do
            find('.destroy-participant').click
            # click confirm on alert
            expect { page.driver.browser.switch_to.alert.accept }.to change(Participant, :count).by(-1)
          end
        end
      end

      context 'when you invite to a friend' do
        it 'adds participant object' do
          within "#user_#{user3.id}" do
            check 'user_ids[]'
          end
          expect do
            find_by_id('send-invite-button').click
          end.to change(Participant, :count).by(1)
        end

        sleep 0.5

        it 'adds the participant to participant cards' do
          pending 'waiting on javascript fix'
          within '#participant-cards' do
            expect(page).to have_content(user3.full_name)
          end
        end

        it 'removes participant from #not_invited_friends' do
          pending 'waiting on javascript fix'
          within '#not_invited_friends' do
            expect(page).to have_no_content(user3.full_name)
          end
        end
      end

      it 'lets the user search for a friend' do
        pending 'friend search not implemented yet'
        expect(page).to have_content('Search for friends')
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
