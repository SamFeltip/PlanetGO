# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Availabilities', js: true do
  let!(:user) { create(:user, full_name: 'John Smith') }

  before do
    Availability.create(user_id: user.id, start_time: Time.zone.at(612_000).to_datetime, end_time: Time.zone.at(622_800).to_datetime)
  end

  context 'when a user is logged in' do
    before do
      login_as user
    end

    describe 'when a user visit their account' do
      before do
        visit '/myaccount'
      end

      it 'shows user their availability' do
        expect(page).to have_selector('.card.bg-success', count: 1)
      end

      describe 'when the user clicks the delete link' do
        before do
          click_link('Delete')
        end

        it 'the availability is removed' do
          expect(page).to have_selector('.card.bg-success', count: 0)
        end
      end

      describe 'when a new availability is created' do
        before do
          select 'Monday', from: 'start_day'
          select '0', from: 'start_hour'
          select '15', from: 'start_minute'
          select 'Monday', from: 'end_day'
          select '4', from: 'end_hour'
          select '45', from: 'end_minute'
          click_button 'Save'
        end

        it 'new availability is visible' do
          sleep 0.5
          expect(page).to have_selector('.card.bg-success', count: 2)
        end
      end

      describe 'when a new availability is created overlapping with a previous availability' do
        before do
          select 'Monday', from: 'start_day'
          select '3', from: 'start_hour'
          select '15', from: 'start_minute'

          select 'Monday', from: 'end_day'
          select '5', from: 'end_hour'
          select '45', from: 'end_minute'

          click_button 'Save'
        end

        it 'the availability gets concatenated to a previous one' do
          expect(page).to have_selector('.card.bg-success', count: 2)
        end
      end

      describe 'when a multi day availability is created' do
        before do
          select 'Monday', from: 'start_day'
          select '22', from: 'start_hour'
          select '0', from: 'start_minute'
          select 'Tuesday', from: 'end_day'
          select '3', from: 'end_hour'
          select '30', from: 'end_minute'
          click_button 'Save'
        end

        it 'an availability spanning multiple days is created' do
          expect(page).to have_selector('.card.bg-success', count: 3)
          expect(page).to have_selector('.card.bg-success', exact_text: 'Delete', count: 2)
        end
      end
    end
  end
end
