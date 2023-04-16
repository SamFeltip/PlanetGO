# frozen_string_literal: true

require 'rails_helper'
require 'faker'

def denial_message(account)
  if account.nil?
    'You need to sign in or sign up before continuing.'
  else
    'You are not authorized to access this page.'
  end
end

shared_context 'when logged in with a commercial account', type: :request do |account_type|
  let!(:category1) { Category.create(name: 'Pub') }
  let!(:account) { create(:user, role: account_type) }
  let!(:other_user) { create(:user, role: User.roles[:user]) }
  let!(:my_interest) { CategoryInterest.where(user_id: account.id, category_id: category1.id).first }
  let!(:other_interest) { CategoryInterest.where(user_id: other_user.id, category_id: category1.id).first }

  before do
    login_as account unless account_type.nil?
  end

  specify 'I can visit the category interests page' do
    visit category_interests_url
    expect(page).to have_content 'Which events do you like most?'
  end

  specify 'I cannot set my interest level for a category interest that is not my own' do
    put set_interest_category_interest_path(other_interest, interest: -1)
    other_interest.reload
    expect(other_interest.interest).to eq 0 # Default value
  end

  specify 'I cannot set my interest level for a category higher than a given range' do
    put set_interest_category_interest_path(my_interest, interest: 100)
    my_interest.reload
    expect(my_interest.interest).to eq 0 # Default value
  end

  specify 'I cannot set my interest level for a category lower than a given range' do
    put set_interest_category_interest_path(my_interest, interest: -100)
    my_interest.reload
    expect(my_interest.interest).to eq 0 # Default value
  end

  context 'when on the categories interest page' do
    before do
      visit category_interests_url
    end

    specify 'I can see a category interest to set' do
      expect(page).to have_content 'Pub'
    end

    specify 'I can only see my category interest to set' do
      expect(page).to have_content('Pub', count: 1)
    end

    context 'when looking at the category' do
      let!(:el) { find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "Pub")]') }

      specify 'I can like the event' do
        within(el) do
          click_on 'like_button'
        end
        my_interest.reload
        expect(my_interest.interest).to eq 1
      end

      specify 'I can dislike the category' do
        within(el) do
          click_on 'dislike_button'
        end
        my_interest.reload
        expect(my_interest.interest).to eq(-1)
      end

      specify 'I can be neutral about the category' do
        my_interest.update(interest: 1)
        within(el) do
          click_on 'neutral_button'
        end
        my_interest.reload
        expect(my_interest.interest).to eq 0
      end
    end
  end
end

shared_context 'when logged in with a non-commercial account', type: :request do |account_type|
  let!(:category1) { Category.create(name: 'Pub') }
  let!(:account) { create(:user, role: account_type) }
  let!(:other_user) { create(:user, role: User.roles[:user]) }
  let!(:other_interest) { CategoryInterest.where(user_id: other_user.id, category_id: category1.id).first }

  before do
    login_as account unless account_type.nil?
  end

  specify 'I cannot visit the category interests page' do
    visit category_interests_url
    expect(page).to have_content denial_message(account_type)
  end

  specify 'I cannot set my interest level for a category interest' do
    put set_interest_category_interest_path(other_interest, interest: -1)
    other_interest.reload
    expect(other_interest.interest).to eq 0 # Default value
  end
end

RSpec.describe 'Category interests', type: :request do
  context 'when logged in as an administrator with users/categories in the system' do
    let!(:account) { create(:user, role: User.roles[:admin]) }

    before do
      Category.create(name: 'Pub')
      create(:user, role: User.roles[:user])
      login_as account
    end

    specify 'I can visit the category interests page' do
      visit category_interests_url
      expect(page).to have_content 'Which events do you like most?'
    end

    context 'when on the category interests page' do
      before do
        visit category_interests_url
      end

      specify 'I cannot see any category interests as I have none' do
        expect(page).not_to have_content 'Pub'
      end
    end
  end

  it_behaves_like 'when logged in with a commercial account', User.roles[:user]
  it_behaves_like 'when logged in with a commercial account', User.roles[:advertiser]
  it_behaves_like 'when logged in with a non-commercial account', nil
  it_behaves_like 'when logged in with a non-commercial account', User.roles[:reporter]
end
