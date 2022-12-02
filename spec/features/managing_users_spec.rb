require 'rails_helper'

RSpec.feature 'Managing users', :type => :request do

  context 'When I am signed in as an administrator' do
    before { 
      @admin = FactoryBot.create(:user, role: 2)
      login_as @admin
    }

    specify 'I cannot edit my own details' do
      expect{visit edit_user_path(@admin)}.to raise_error(CanCan::AccessDenied)
    end

    specify 'I cannot delete my own account' do
      expect{delete user_path(@admin)}.to raise_error(CanCan::AccessDenied)
    end

    specify 'I can visit the account management page' do
      visit '/users'
      expect(current_path).to eq '/users'
    end

    context 'When I am on the homepage' do
      before { visit '/' }

      specify 'I can see the link to the users management page' do
        expect(page).to have_content 'Account Management'
      end
    end

    context 'When I am on the account management page' do
      before { visit '/users' }

      specify 'There is no option to edit my account' do
        expect(page).to_not have_content 'Edit'
      end

      specify 'There is no option to Destroy my account' do
        expect(page).to_not have_content 'Destroy'
      end

      context 'There are users in the system' do
        before { 
          FactoryBot.create(:user, email: 'user1@user.com')
          refresh
        }

        specify 'I can see users on the system' do
          expect(page).to have_content 'user1@user.com'
        end
        
        specify 'I can edit the user role' do
          click_on 'Edit'
          select 'reporter', :from => "Role"
          click_on 'Save'
          expect(page).to have_content 'reporter'
        end

        specify 'I can destroy the user' do
          click_on 'Destroy'
          expect(page).to_not have_content 'user1@user.com'
        end
      end
    end
  end

  context 'I am signed in as a user' do
    before { login_as FactoryBot.create(:user, role: 0) }

    specify 'I cannot visit the account management page' do
      expect{visit '/users'}.to raise_error(CanCan::AccessDenied)
    end

    context 'When I am on the homepage' do
      before { visit '/' }

      specify 'I cannot see the link to the users management page' do
        expect(page).to_not have_content 'Account Management'
      end
    end

    context 'When there are users in the system' do
      before { @user = FactoryBot.create(:user, email: 'user1@user.com') }

      specify 'I cannot view their account info' do
        expect {visit user_path(@user)}.to raise_error(CanCan::AccessDenied)
      end

      specify 'I cannot edit their account info' do
        expect {visit edit_user_path(@user)}.to raise_error(CanCan::AccessDenied)
      end

      specify 'I cannot delete their account' do
        expect {delete user_path(@user)}.to raise_error(CanCan::AccessDenied)
      end
    end
  end
end
