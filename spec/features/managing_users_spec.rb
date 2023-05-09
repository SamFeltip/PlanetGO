# frozen_string_literal: true

require 'rails_helper'

def denial_message(account)
  if account.nil?
    'You need to sign in or sign up before continuing.'
  else
    'You are not authorized to access this page.'
  end
end

shared_context 'non-admin account', type: :request do |account_type|
  let!(:account) { create(:user, role: account_type) }
  before do
    login_as account unless account_type.nil?
  end

  let!(:user1) { create(:user, email: 'user1@user.com') }
  let!(:user2) { create(:user, email: 'user2@user.com', suspended: true) }

  specify 'I cannot visit the account management page' do
    visit '/users'
    expect(page).to have_content denial_message(account_type)
  end

  context 'when I am on the homepage' do
    before { visit '/' }

    specify 'I cannot see the link to the users management page' do
      expect(page).not_to have_content 'Account Management'
    end
  end

  specify 'I cannot view a users account info' do
    visit user_path(user1)
    expect(page).to have_content denial_message(account_type)
  end

  specify 'I cannot edit a users account info' do
    visit edit_user_path(user1)
    expect(page).to have_content denial_message(account_type)
  end

  specify 'I cannot delete an account' do
    expect do
      login_as account
      delete user_path(user1)
    end.not_to change(User, :count)
  end

  specify 'I cannot lock an account' do
    put lock_user_path(user1)
    expect(user1.access_locked?).to be(false)
  end

  specify 'I cannot unlock an account' do
    user2.lock_access!({ send_instructions: false })
    put unlock_user_path(user2)
    expect(user2.access_locked?).to be(true)
  end

  specify 'I cannot suspend a commercial account' do
    expect do
      login_as account
      put suspend_user_path(user1)
      user1.reload
    end.not_to change(user1, :suspended)
  end

  specify 'I cannot reinstate a commercial account' do
    expect do
      login_as account
      put suspend_user_path(user2)
      user2.reload
    end.not_to change(user2, :suspended)
  end
end

RSpec.describe 'Managing users', type: :request do
  let!(:admin1) { create(:user, email: 'admin1@admin.com', role: 'admin') }

  context 'when logging in and out' do
    before do
      login_as admin1
    end

    context 'when I log out of my account' do
      before do
        visit '/myaccount'
        click_on 'Sign out'
      end

      specify 'should show a signed out notice' do
        expect(page).to have_content('Signed out successfully.')
      end

      specify 'should take the user to the root page' do
        expect(page).to have_current_path('/', ignore_query: true)
      end
    end
  end

  context 'when signed in as an administrator and there are users in the system' do
    let!(:admin1) { create(:user, full_name: 'Greg H', email: 'admin1@admin.com', role: 'admin') }

    before do
      login_as admin1
    end

    specify 'I cannot edit my own details' do
      visit edit_user_path(admin1)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'I cannot lock my own account' do
      put lock_user_path(admin1)
      expect(admin1.access_locked?).to be(false)
    end

    specify 'I cannot unlock my own account' do
      admin1.lock_access!({ send_instructions: false })
      put unlock_user_path(admin1)
      expect(admin1.access_locked?).to be(true)
    end

    specify 'I cannot suspend my own account' do
      expect do
        put suspend_user_path(admin1)
        admin1.reload
      end.not_to change(admin1, :suspended)
    end

    specify 'I can visit the account management page' do
      visit '/users'
      expect(page).to have_current_path '/users'
    end

    context 'when I am on the homepage' do
      before { visit '/' }

      specify 'I can see the link to the users management page' do
        expect(page).to have_content 'Accounts'
      end
    end

    context 'when I am on the account management page' do
      before { visit '/users' }

      let!(:el) { find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "Greg H")]') }

      specify 'I can see my account' do
        expect(page).to have_content 'Greg H'
      end

      specify 'There is no option to edit my account' do
        expect(el).not_to have_content 'Edit'
      end

      specify 'There is no option to Destroy my account' do
        expect(el).not_to have_content 'Destroy'
      end

      specify 'There is the option to Show my account' do
        expect(el).to have_content 'Show'
      end

      specify 'There is no option to Lock my account' do
        expect(el).not_to have_button 'Block' or have_button 'Unblock'
      end

      specify 'There is no option to Suspend my account' do
        expect(el).not_to have_button 'Suspend' or have_button 'Reinstate'
      end

      context 'when looking at a user' do
        before do
          create(:user, full_name: 'user1', email: 'user1@user.com')
          refresh
          @user_content = find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "user1")]')
        end

        specify 'I can show user details' do
          within(@user_content) { click_on 'Show' }
          expect(page).to have_content '2023-01-12' # The factory last sign in date
        end

        specify 'I can edit the user role' do
          within(@user_content) { click_on 'Edit' }
          select 'reporter', from: 'Role'
          click_on 'Save'
          expect(@user_content).to have_content 'reporter'
        end

        specify 'I can destroy the user' do
          within(@user_content) { click_on 'Destroy' }
          expect(page).not_to have_content 'user1@user.com'
        end
      end

      context 'when the user is not suspended' do
        let!(:user) { create(:user, full_name: 'user1', email: 'user1@user.com') }

        before do
          refresh
          @user_content = find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "user1")]')
        end

        specify 'I can suspend a commercial account' do
          expect do
            within(@user_content) { click_on 'Suspend' }
            user.reload
          end.to change(user, :suspended)
        end
      end

      context 'when looking at a suspended account' do
        let!(:user) { create(:user, full_name: 'user2', email: 'user2@user.com', suspended: true) }

        before do
          refresh
          @user_content = find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "user2")]')
        end

        specify 'I can reinstate a commercial account' do
          expect do
            within(@user_content) { click_on 'Reinstate' }
            user.reload
          end.to change(user, :suspended)
        end
      end

      context 'when the user is not locked' do
        let!(:user) { create(:user, full_name: 'user1', email: 'user1@user.com') }

        before do
          refresh
          @user_content = find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "user1")]')
        end

        specify 'I can lock an account' do
          within(@user_content) { click_on 'Block' }
          user.reload
          expect(user.access_locked?).to be(true)
        end
      end

      context 'when the user is locked' do
        let!(:user) { create(:user, full_name: 'user2', email: 'user2@user.com', suspended: true) }

        before do
          user.lock_access!({ send_instructions: false })
          refresh
          @user_content = find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "user2")]')
        end

        specify 'I can unlock and account' do
          within(@user_content) { click_on 'Unblock' }
          user.reload
          expect(user.access_locked?).to be(false)
        end
      end

      context 'when looking at a non-commercial account' do
        let!(:user) { create(:user, full_name: 'rep1', email: 'rep1@rep.com', role: 'reporter') }

        before do
          refresh
          @user_content = find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "rep1")]')
        end

        specify 'I cannot see an option to suspend' do
          within(@user_content) { click_on 'Edit' }
          expect(page).not_to have_button 'Suspend'
        end

        specify 'I cannot suspend' do
          expect do
            login_as admin1
            put suspend_user_path(user)
            user.reload
          end.not_to change(user, :suspended)
        end
      end
    end
  end

  context 'when signed in as a non administrator' do
    it_behaves_like 'non-admin account', nil
    it_behaves_like 'non-admin account', 'user'
    it_behaves_like 'non-admin account', 'reporter'
    it_behaves_like 'non-admin account', 'advertiser'
  end
end
