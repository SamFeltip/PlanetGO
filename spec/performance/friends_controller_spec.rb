# frozen_string_literal: true

require 'rails_helper'
require 'rspec-benchmark'

RSpec.describe FriendsController, type: :controller do
  include RSpec::Benchmark::Matchers

  let(:current_user) { create(:user) }
  let(:user) { create(:user) }

  before { sign_in(current_user) }

  describe '#index' do
    it 'performs well', :performance do
      100.times do
        friend = create(:user)
        friend.send_follow_request_to(current_user)
        current_user.accept_follow_request_of(friend)
      end

      expect { get :index }.to perform_under(20).ms
    end
  end

  describe '#search' do
    it 'performs well', :performance do
      create_list(:user, 200)

      expect { get :search, params: { search: { name: 'John' } } }.to perform_under(30).ms
    end
  end

  describe '#requests' do
    it 'performs well', :performance do
      200.times do
        friend = create(:user)
        friend.send_follow_request_to(current_user)
      end

      expect { get :requests }.to perform_under(20).ms
    end
  end

  describe '#follow' do
    it 'performs well', :performance do
      expect do
        post :follow, params: { id: user.id }
      end.to perform_under(20).ms
    end
  end

  describe '#unfollow' do
    it 'performs well', :performance do
      user.send_follow_request_to(current_user)
      current_user.accept_follow_request_of(user)

      expect do
        post :unfollow, params: { id: user.id }
      end.to perform_under(20).ms
    end
  end

  describe '#decline' do
    it 'performs well', :performance do
      user.send_follow_request_to(current_user)

      expect do
        post :decline, params: { id: user.id }
      end.to perform_under(20).ms
    end
  end

  describe '#cancel' do
    it 'performs well', :performance do
      current_user.send_follow_request_to(user)

      expect do
        post :cancel, params: { id: user.id }
      end.to perform_under(20).ms
    end
  end
end
