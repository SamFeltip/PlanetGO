# frozen_string_literal: true

require 'rails_helper'
require 'rspec-benchmark'

RSpec.describe EventsController, type: :controller do
  include RSpec::Benchmark::Matchers

  describe '#index' do
    it 'performs well' do
      create_list(:event, 100)

      expect do
        get :index
      end.to perform_under(20).ms
    end
  end

  describe '#show' do
    it 'performs well' do
      event = create(:event_with_likes)

      expect do
        get :show, params: { id: event.id }
      end.to perform_under(20).ms
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
      event = create(:event_with_likes)

      expect do
        get :edit, params: { id: event.id }
      end.to perform_under(20).ms
    end
  end

  describe '#create' do
    it 'performs well' do
      event_params = attributes_for(:event)

      expect do
        post :create, params: { event: event_params }
      end.to perform_under(20).ms
    end
  end

  describe '#update' do
    it 'performs well' do
      event = create(:event_with_likes)
      event_params = attributes_for(:event)

      expect do
        put :update, params: { id: event.id, event: event_params }
      end.to perform_under(20).ms
    end
  end

  describe '#destroy' do
    it 'performs well' do
      event = create(:event_with_likes)

      expect do
        delete :destroy, params: { id: event.id }
      end.to perform_under(20).ms
    end
  end
end
