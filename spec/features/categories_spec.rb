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

shared_context 'when logged in as non-admin account', type: :request do |account_type|
  let!(:account) { create(:user, role: account_type) }
  let!(:category1) { Category.create(name: 'Bar') }

  before do
    login_as account unless account_type.nil?
  end

  specify 'I cannot visit the categories management page' do
    visit '/categories'
    expect(page).to have_content denial_message(account_type)
  end

  specify 'I cannot show category information' do
    visit category_path(category1)
    expect(page).to have_content denial_message(account_type)
  end

  specify 'I cannot edit a category' do
    visit edit_category_path(category1)
    expect(page).to have_content denial_message(account_type)
  end

  specify 'I cannot destroy a category' do
    expect do
      login_as account
      delete category_path(category1)
    end.not_to change(Category, :count)
  end

  specify 'I cannot create a category' do
    visit new_category_path
    expect(page).to have_content denial_message(account_type)
  end
end

RSpec.describe 'Categories' do
  context 'when there are categories/users in the system and I am logged in as an admin' do
    before do
      login_as create(:user, role: User.roles[:admin])
      Category.create(name: 'Bar')
      create(:user, role: User.roles[:user])
    end

    specify 'I can visit the categories management page' do
      visit '/categories'
      expect(page).to have_content 'Listing Categories'
    end

    context 'when on the categories management page' do
      before do
        visit '/categories'
      end

      specify 'I can see categories within the system' do
        expect(page).to have_content 'Bar'
      end

      specify 'I can create a new category' do
        click_on 'New Category'
        fill_in 'Name', with: 'Disco'
        click_on 'Save'
        visit '/categories'
        expect(page).to have_content 'Disco'
      end

      context 'when looking at a category' do
        let!(:el) { find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "Bar")]') }

        specify 'I can show user reactions to the category' do
          within(el) { click_on 'Show' }
          expect(page).to have_content '100.00%' # All users indifferent
        end

        specify 'I can edit the category name' do
          within(el) { click_on 'Edit' }
          fill_in 'Name', with: 'Pub'
          click_on 'Save'
          expect(page).to have_content 'Pub'
        end

        specify 'I can delete a category' do
          within(el) { click_on 'Destroy' }
          expect(page).not_to have_content 'Bar'
        end
      end
    end
  end

  context 'when not logged in as an admin do' do
    it_behaves_like 'when logged in as non-admin account', nil
    it_behaves_like 'when logged in as non-admin account', 'user'
    it_behaves_like 'when logged in as non-admin account', 'reporter'
    it_behaves_like 'when logged in as non-admin account', 'advertiser'
  end
end
