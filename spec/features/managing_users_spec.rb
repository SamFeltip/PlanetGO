# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing users', type: :request do
  context 'Signed in as an administrator' do
    before do
      @admin = create(:user, role: User.roles[:admin])
      login_as @admin
    end

    specify 'I cannot edit my own details' do
      visit edit_user_path(@admin)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'I cannot delete my own account' do
      visit edit_user_path(@admin)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'I can visit the account management page' do
      visit '/users'
      expect(page).to have_current_path '/users'
    end

    context 'When I am on the homepage' do
      before { visit '/' }

      specify 'I can see the link to the users management page' do
        expect(page).to have_content 'Accounts'
      end
    end

    context 'When I am on the account management page' do
      before { visit '/users' }

      specify 'There is no option to edit my account' do
        expect(page).not_to have_css('#btn-outline-secondary', text: 'Edit')
      end

      specify 'There is no option to destroy my account' do
        expect(page).not_to have_content 'Destroy'
      end

      context 'There are users in the system' do
        before do
          create(:user, email: 'user1@user.com')
          refresh
        end

        specify 'I can see users on the system' do
          expect(page).to have_content 'user1@user.com'
        end

        specify 'I can show user details' do
          click_on 'Show'
          expect(page).to have_content 'User details'
        end

        specify 'I can edit the user role' do
          click_on 'Edit'
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
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    context 'When I am on the homepage' do
      before { visit '/' }

      specify 'I cannot see the link to the users management page' do
        expect(page).not_to have_content 'Account Management'
      end
    end

    context 'When there are users in the system' do
      before { @user = create(:user, email: 'user1@user.com') }

      specify 'I cannot view their account info' do
        visit user_path(@user)
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot edit their account info' do
        visit edit_user_path(@user)
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot delete their account' do
        expect do
          delete user_path(@user)
        end.not_to change(User, :count)
      end
    end
  end

  context 'Signed in as a user' do
    before { login_as create(:user, role: 0) }

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
      before { @user = create(:user, email: 'user1@user.com') }

      specify 'I cannot view their account info' do
        visit user_path(@user)
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot edit their account info' do
        visit edit_user_path(@user)
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot delete their account' do
        expect do
          delete user_path(@user)
        end.not_to change(User, :count)
      end
    end
  end

  context 'Signed in as a reporter' do
    before { login_as create(:user, role: 1) }

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
      before { @user = create(:user, email: 'user1@user.com') }

      specify 'I cannot view their account info' do
        visit user_path(@user)
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot edit their account info' do
        visit edit_user_path(@user)
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot delete their account' do
        expect do
          delete user_path(@user)
        end.not_to change(User, :count)
      end
    end
  end
end
