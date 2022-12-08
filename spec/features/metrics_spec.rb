# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Managing users', type: :request do
  context 'When I am signed in as an admin' do
    before do
      @admin = FactoryBot.create(:user, role: 2)
      login_as @admin
    end

    specify 'I can visit the account management page' do
      visit '/metrics'
      expect(current_path).to eq '/metrics'
    end

    context 'There are metrics in the system' do
      before do
        @metric = FactoryBot.create(:metric, route: 'Rue de testing')
      end

      specify 'I can view the metric' do
        visit metric_path(@metric)
        expect(page).to have_content 'Rue de testing'
      end
    end
  end

  context 'When I am signed in as a reporter' do
    before do
      @reporter = FactoryBot.create(:user, role: 1)
      login_as @reporter
    end

    specify 'I can visit the account management page' do
      visit '/metrics'
      expect(current_path).to eq '/metrics'
    end

    context 'There are metrics in the system' do
      before do
        @metric = FactoryBot.create(:metric, route: 'Rue de testing')
      end

      specify 'I can view the metric' do
        visit metric_path(@metric)
        expect(page).to have_content 'Rue de testing'
      end
    end
  end

  context 'I am signed in as a user' do
    before do
      @user = FactoryBot.create(:user, role: 0)
      login_as @user
    end

    specify 'I cannot visit the account management page' do
      visit '/metrics'
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    context 'When metrics are in the system' do
      before { @metric = FactoryBot.create(:metric) }

      specify 'I cannot view the metric' do
        visit metric_path(@metric)
        expect(page).to have_content 'You are not authorized to access this page.'
      end
    end
  end
end
