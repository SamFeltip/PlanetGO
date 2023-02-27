# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing users', type: :request do
  context 'When signed in as an administrator' do
    let!(:admin1) { FactoryBot.create(:user, email: 'admin1@admin.com', role: 2) }

    before do
      login_as admin1
    end

    specify 'I cannot edit my own details' do
      visit edit_user_path(admin1)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'I cannot delete my own account' do
      visit edit_user_path(admin1)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'I can visit the account management page' do
      visit '/users'
      expect(page).to have_current_path '/users'
    end

    context 'When I am on the homepage' do
      before { visit '/' }

      specify 'I can see the link to the users management page' do
        expect(page).to have_content 'Account Management'
      end
    end

    context 'When I am on the account management page' do
      before { visit '/users' }

      let!(:el) { find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "admin1")]') }

      specify 'I can see my account' do
        expect(page).to have_content 'admin1@admin.com'
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

      context 'There are users in the system' do
        before do
          FactoryBot.create(:user, email: 'user1@user.com')
          refresh
        end

        let(:user_content) { find(:xpath, '/html/body/main/div/div/table/tbody/tr[contains(., "user1")]') }

        specify 'I can see users on the system' do
          expect(page).to have_content 'user1@user.com'
        end

        specify 'I can show user details' do
          within(user_content) do
            click_on 'Show'
          end
          expect(page).to have_content '2023-01-12'
        end

        specify 'I can edit the user role' do
          within(user_content) do
            click_on 'Edit'
          end
          select 'reporter', from: 'Role'
          click_on 'Save'
          expect(page).to have_content 'reporter'
        end

        specify 'I can destroy the user' do
          click_on 'Destroy'
          expect(page).not_to have_content 'user1@user.com'
        end
      end
    end
  end

  context 'Not signed in' do
    specify 'I cannot visit the account management page' do
      visit '/users'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    context 'When I am on the homepage' do
      before { visit '/' }

      specify 'I cannot see the link to the users management page' do
        expect(page).not_to have_content 'Account Management'
      end
    end

    context 'When there are users in the system' do
      let!(:user1) { FactoryBot.create(:user, email: 'user1@user.com') }

      specify 'I cannot view their account info' do
        visit user_path(user1)
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      specify 'I cannot edit their account info' do
        visit edit_user_path(user1)
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      specify 'I cannot delete their account' do
        expect do
          delete user_path(user1)
        end.not_to change(User, :count)
      end
    end
  end

  context 'Signed in as a user' do
    before { login_as FactoryBot.create(:user, role: 0) }

    specify 'I cannot visit the account management page' do
      visit '/users'
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    context 'When I am on the homepage' do
      before { visit '/' }

      specify 'I cannot see the link to the users management page' do
        expect(page).not_to have_content 'Account Management'
      end
    end

    context 'When there are users in the system' do
      let!(:user1) { FactoryBot.create(:user, email: 'user1@user.com') }

      specify 'I cannot view their account info' do
        visit user_path(user1)
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot edit their account info' do
        visit edit_user_path(user1)
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot delete their account' do
        expect do
          delete user_path(user1)
        end.not_to change(User, :count)
      end
    end
  end

  context 'Signed in as a reporter' do
    before { login_as FactoryBot.create(:user, role: 1) }

    specify 'I cannot visit the account management page' do
      visit '/users'
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    context 'When I am on the homepage' do
      before { visit '/' }

      specify 'I cannot see the link to the users management page' do
        expect(page).not_to have_content 'Account Management'
      end
    end

    context 'When there are users in the system' do
      let!(:user1) { FactoryBot.create(:user, email: 'user1@user.com') }

      specify 'I cannot view their account info' do
        visit user_path(user1)
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot edit their account info' do
        visit edit_user_path(user1)
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot delete their account' do
        expect do
          delete user_path(user1)
        end.not_to change(User, :count)
      end
    end
  end
end
