# frozen_string_literal: true

require 'rails_helper'
require 'rspec-benchmark'

RSpec.describe OutingsController, type: :controller do
  include RSpec::Benchmark::Matchers

  let(:current_user) { create(:user) }

  before { sign_in(current_user) }

  describe '#index' do
    it 'performs well' do
      create_list(:outing, 100)

      expect do
        get :index
      end.to perform_under(20).ms
    end
  end

  describe '#show' do
    it 'performs well' do
      outing = create(:outing)

      expect do
        get :show, params: { invite_token: outing.invite_token }
      end.to perform_under(25).ms
    end
  end

  describe '#new' do
    it 'performs well' do
      expect do
        get :new
      end.to perform_under(20).ms
    end
  end

  describe '#edit' do
    it 'performs well' do
      outing = create(:outing)

      expect do
        get :edit, params: { invite_token: outing.invite_token }
      end.to perform_under(20).ms
    end
  end

  describe '#create' do
    it 'performs well' do
      outing_params = attributes_for(:outing)
      outing_params.delete(:creator_id)

      expect do
        post :create, params: { outing: outing_params }
      end.to perform_under(20).ms
    end
  end

  describe '#update' do
    it 'performs well' do
      outing = create(:outing)
      outing_params = attributes_for(:outing)

      expect do
        put :update, params: { invite_token: outing.invite_token, outing: outing_params }
      end.to perform_under(20).ms
    end
  end

  describe '#destroy' do
    it 'performs well' do
      outing = create(:outing)

      expect do
        delete :destroy, params: { invite_token: outing.invite_token }
      end.to perform_under(20).ms
    end
  end
end
