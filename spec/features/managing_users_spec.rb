require 'rails_helper'

RSpec.feature 'Managing users' do

  context 'When I am signed in as an administrator' do
    before {login_as FactoryBot.create(:user, role: 2)}

    specify 'I can visit the account management page' do
      visit '/users'
      expect(current_path).to eq '/users'
    end

    context 'When I am on the homepage' do
      before {visit '/'}

      specify 'I can see the link to the users management page' do
        expect(page).to have_content 'Account Management'
      end
    end

    context 'There are users in the system' do
      before{FactoryBot.create(:user, email: 'user1@user.com')}

      context 'When I am on the account management page' do
        before {visit '/users'}

        specify 'I can see users on the system' do
          expect(page).to have_content 'user1@user.com'
        end
        
        specify 'I can edit the user role' do
          click_on 'Edit'
          select 'reporter', :from => "Role"
          click_on 'Save'
          expect(page).to have_content 'reporter'
        end
      end
    end
  end
end