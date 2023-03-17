# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe 'Outings' do
  before do
    @outing_creator = create(:user)
    @past_outing = create(:outing, name: "past outing", creator_id: @outing_creator.id, date: Time.now - 1.week)
    @future_outing = create(:outing, creator_id: @outing_creator.id, name: "future outing", date: Time.now + 1.week)

    login_as @outing_creator
  end


  context "setting up user" do
    it "should record the creators name in the user object" do
      expect(@outing_creator.full_name).to eq 'John Smith'
      expect(@past_outing.creator).to eq @outing_creator
    end
  end

  context 'when a user is logged in' do
    describe 'user visit their account' do
      before :each do
        visit "/myaccount"
        @future_outings_element = find("#future_outings")
        @past_outings_element = find("#past_outings")
      end


      it "shows user their future outings" do
        expect(@future_outings_element).to have_content(@future_outing.name)
      end

      it "only shows future outings in the future outings element" do
        expect(@future_outings_element).to have_no_content(@past_outing.name)
      end

      it "shows user their past outings" do
        past_outings_element = find("#past_outings")

        expect(past_outings_element).to have_content(@past_outing.name)
        expect(past_outings_element).to have_no_content(@future_outing.name)

      end
    end




    describe 'lets the user create an outing' do
      outing_name = "New outing"

      outing_year = "2023"
      outing_month = "March"
      outing_day = "15"

      outing_date = "2023-03-15"
      outing_desc = "a fun outing!"
      outing_type = "open"

      before do
        visit "/outings"
        click_link 'New Outing'

        # the user clicks on the button "New Outing"
        # the user fills in a name, a date, a description, and selects "open" as the outing type

        fill_in 'Name', with: outing_name
        # find('outing[date(1i)]').set(outing_year)
        # find('outing[date(2i)]').set(outing_month)
        # find('outing[date(3i)]').set(outing_day)

        fill_in 'Date', with: outing_date

        fill_in 'Description', with: outing_desc
        select outing_type, from: 'Outing type'

        # the user clicks the "save" button
        click_button 'Save'
      end

      it "saves an outing" do
        # expect the program to create an outing object with the above information, and with a creator_id of the logged in user's user_id
        expect(Outing.last).to have_attributes(
          name: outing_name,
          date: Date.parse(outing_date),
          description: outing_desc,
          creator_id: @outing_creator.id)
      end

      it "creates a participant" do
        # expect the program to create a participant with current_user and new outing present, and the status set to "creator"
        expect(Participant.last).to have_attributes(
          user_id: @outing_creator.id,
          outing_id: Outing.last.id,
          status: 'creator')
      end

      it "alerts the user" do
        # show a notice saying the outing was created
        expect(page).to have_content('Outing was successfully created.')
      end

      it "redirects the user to outings index" do

        # redirect to the outings index page
        expect(page).to have_current_path(outings_path)
      end

      it "displays the outing on the outings/index page" do
        # show the outing's name in the page html
        expect(page).to have_content(outing_name)
      end
    end

    describe 'lets the user inspect an outing' do

    end

    describe 'lets the user accept an outing invite' do

    end

    describe 'lets a user delete their own outings' do

    end

    describe "doesnt let a user delete someone elses outings" do

    end
  end

  context 'when the user is not logged in' do
    describe 'when the user joins by a link' do
      describe 'forces them to make an account' do
        # redirects to new account page with a notice
        it 'redirects them to the outing, with their account authenticated on this outing' do
          # on signup redirect
        end
      end

    end


    it 'does not let them view outings' do

    end

    it 'does not let them accept outing invites' do

    end

    it 'does not let the user create an outing' do

    end
  end

  context 'when a user wants to change outing details' do
    describe "when a user is logged in as the outing creator" do
      it 'lets them add an event to an exist outing' do

      end

      it 'lets them remove an event from an existing outing' do
        
      end

    end
  end
end
