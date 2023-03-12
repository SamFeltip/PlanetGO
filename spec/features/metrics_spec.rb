# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing metrics', type: :request do
  context 'When I am signed in as an admin' do
    before do
      @admin = create(:user, role: 'admin')
      login_as @admin
    end

    specify 'I can visit the metrics management page' do
      visit '/metrics'
      expect(page).to have_current_path '/metrics'
    end

    context 'There are metrics in the system' do
      before do
        @metric = create(:metric, route: '/')
      end

      context 'I am on the metrics page' do
        before do
          visit '/metrics'
          expect(page).to have_current_path '/metrics'
        end

        specify 'I can view my visit to the page' do
          expect(page).to have_selector('div', text: '1')
        end

        specify 'The graph should be empty by default' do
          expect(page).to have_selector('#myChart')
          expect(page).to have_css('canvas[data-labels="[0, 1]"]')
        end
      end
    end
  end

  context 'When I am signed in as a reporter' do
    before do
      @reporter = create(:user, role: 'reporter')
      login_as @reporter
    end

    specify 'I can visit the metrics management page' do
      visit '/metrics'
      expect(page).to have_current_path '/metrics'
    end

    context 'There are metrics in the system' do
      before do
        @metric = create(:metric, route: '/')
      end

      context 'I am on the metrics page' do
        before do
          visit '/metrics'
          expect(page).to have_current_path '/metrics'
        end

        specify 'I can view my visit to the page' do
          # Since the admin visited the metrics page earlier, the reporter's visit is the second visit to the metrics page
          expect(page).to have_selector('div', text: '2')
        end

        specify 'The graph should be empty by default' do
          expect(page).to have_selector('#myChart')
          expect(page).to have_css('canvas[data-labels="[0, 1]"]')
        end
      end
    end
  end

  context 'I am signed in as a user' do
    before do
      @user = create(:user, role: 'user')
      login_as @user
    end

    specify 'I cannot visit the metric management page' do
      visit '/metrics'
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end
end
