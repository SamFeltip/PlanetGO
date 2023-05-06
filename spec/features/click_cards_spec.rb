# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Clicking on a click card' do
  let!(:user) { create(:user) }

  before do
    login_as user
  end

  context 'when visiting the events index page' do
    let!(:event) { create(:event, approved: true) }

    before do
      visit events_path
    end

    context 'when clicking on an event card' do
      before do
        find("#event_#{event.id}.click-card").click
      end

      it 'redirects to the event show page', js: true do
        expect(page).to have_current_path(event_path(event))
      end
    end
  end

  context 'when visiting the outings index page' do
    let!(:outing) { create(:outing, creator_id: user.id) }

    before do
      visit outings_path
    end

    context 'when clicking on an outing card' do
      before do
        find("#outing_#{outing.id}.click-card").click
      end

      it 'redirects to the outing show page', js: true do
        expect(page).to have_current_path(outing_path(outing))
      end
    end
  end
end
