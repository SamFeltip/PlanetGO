# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
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
      event = create(:event_with_event_reacts)

      expect do
        get :show, params: { id: event.id }
      end.to perform_under(10).ms
    end
  end

  describe '#new' do
    it 'performs well' do
      expect do
        get :new
      end.to perform_under(10).ms
    end
  end

  describe '#edit' do
    it 'performs well' do
      event = create(:event_with_event_reacts)

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
      end.to perform_under(10).ms
    end
  end

  describe '#update' do
    it 'performs well' do
      event = create(:event_with_event_reacts)
      event_params = attributes_for(:event)

      expect do
        put :update, params: { id: event.id, event: event_params }
      end.to perform_under(10).ms
    end
  end

  describe '#destroy' do
    it 'performs well' do
      event = create(:event_with_event_reacts)

      expect do
        delete :destroy, params: { id: event.id }
      end.to perform_under(10).ms
    end
  end
end
