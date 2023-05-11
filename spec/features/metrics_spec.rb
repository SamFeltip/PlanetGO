# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing metrics', type: :request do
  context 'When I am signed in as an admin' do
    before do
      @admin = create(:user, role: User.roles[:admin])
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

        specify 'I can see the metric on the page' do
          expect(page).to have_selector('div', text: '1')
        end

        specify 'The graph should be empty by default' do
          expect(page).to have_selector('#myChart')
          expect(page).to have_css('canvas[data-labels="[0, 1]"]')
        end
      end
    end

    context 'There are less visits in the last 7 days than the previous 7 days' do
      before do
        @metric1 = create(:metric, route: '/', time_enter: (DateTime.now - 24.hours), time_exit: (DateTime.now - 23.hours))
        @metric2 = create(:metric, route: '/', time_enter: (DateTime.now - 9.days), time_exit: (DateTime.now - 8.days))
        @metric3 = create(:metric, route: '/', time_enter: (DateTime.now - 10.days), time_exit: (DateTime.now - 9.days))
      end

      context 'I am on the metrics page' do
        before do
          visit '/metrics'
          expect(page).to have_current_path '/metrics'
        end

        specify 'I can see the correct number of visits in the last 7 days' do
          expect(page).to have_css('span.num_visits', text: '1', count: 1)
        end

        specify 'I can see the correct number of visits in the 7 days before that' do
          expect(page).to have_css('span.end_text', text: '2 in the previous week', count: 1)
        end

        specify 'I can see the correct percent difference between these two' do
          expect(page).to have_css('span.percentage', text: '50%', count: 1)
        end

        specify 'The percent difference is highlited in red' do
          save_page
          expect(page).to have_css('span.percentage.negative', count: 1)
        end
      end
    end
  end

  context 'When I am signed in as a reporter' do
    before do
      @reporter = create(:user, role: User.roles[:reporter])
      login_as @reporter
    end

    specify 'I can visit the metrics management page' do
      visit '/metrics'
      expect(page).to have_current_path '/metrics'
    end

    context 'There are metrics in the system' do
      before do
        @metric = create(:metric, route: '/')
        @metric = create(:metric, route: '/')
        @metric = create(:metric, route: '/')
      end

      context 'I am on the metrics page' do
        before do
          visit '/metrics'
          expect(page).to have_current_path '/metrics'
        end

        specify 'I can see the metrics on the page' do
          expect(page).to have_selector('div', text: '3')
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
      @user = create(:user, role: User.roles[:user])
      login_as @user
    end

    specify 'I cannot visit the metric management page' do
      visit '/metrics'
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end
end
