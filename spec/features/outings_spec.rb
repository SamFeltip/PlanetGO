# frozen_string_literal: true

# frozen_string_lspecifyeral: true

require 'rails_helper'
require 'faker'

RSpec.describe 'Outings' do
  context 'when a user is logged in' do
    specify 'lets the user see all outings' do
    end

    specify 'lets the user create an outing' do
    end

    specify 'lets the user inspect an outing' do
    end

    specify 'lets the user accept an outing invspecifye' do
    end

    specify 'lets a user delete their own outings' do
    end

    specify 'doesnt let a user delete someone elses outings' do
    end
  end

  context 'when the user is not logged in' do
    context 'when the user joins by a link' do
      specify 'forces them to make an account' do
        # redirects to new account page wspecifyh a notice
      end

      specify 'redirects them to the outing, wspecifyh their account authenticated on this outing' do
        # on signup redirect
      end
    end

    specify 'does not let them view outings' do
    end

    specify 'does not let them accept outing invites' do
    end

    specify 'does not let the user create an outing' do
    end
  end

  context 'when a user wants to change outing details' do
    context 'when a user is logged in as the outing creator' do
      specify 'lets them add an event to an exist outing' do
      end

      specify 'lets them remove an event from an existing outing' do
      end
    end
  end
end
