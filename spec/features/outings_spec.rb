# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe 'Outings' do

  context 'when a user is logged in' do
    it 'lets the user see all outings'do

    end

    it 'lets the user create an outing' do

    end

    it 'lets the user inspect an outing' do

    end

    it 'lets the user accept an outing invite' do

    end

    it 'lets a user delete their own outings' do

    end

    it "doesnt let a user delete someone elses outings" do

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
