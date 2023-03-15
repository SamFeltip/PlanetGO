# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe 'Outings' do
  before do
    outing_creator = build(:user)
    creator = create_list(:user, outing_creator)
    past_outing = build(:outing, name: "past outing", users: creator, date: Time.now - 1.week)
    future_outing = build(:outing, users: creator, name: "future outing", date: Time.now + 1.week)

  end


  context "setter" do
    it "should do this" do
      expect(outing_creator.full_name).to eq 'John Smith'
    end
  end

  context 'when a user is logged in' do
    let 'user visit their account' do
      visit "/myaccount"
      it "shows user their past outing" do
        puts "something"
        expect(page).to have_content(:past_outing.name)
      end
    end

    describe 'lets the user create an outing' do

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
