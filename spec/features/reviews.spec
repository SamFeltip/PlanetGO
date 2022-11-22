require 'rails_helper'

RSpec.feature 'Reviews' do
    context 'When I am not logged in' do
        before { FactoryBot.create(:review, body: 'I absolutely love this website, would recommend to anyone.') }

        specify 'I can see existing reviews' do
            visit '/reviews'
            expect(page).to have_content 'Listing Reviews'
            expect(page).to have_content 'I absolutely love this website, would recommend to anyone.'
            expect(page).to have_content 'myemail@email.com'
        end

        specify 'I cannot add a new review' do
            visit '/reviews'
            click_on 'New Review'
            expect(page).to have_content 'You need to sign in or sign up before continuing.'
        end
    end

    context 'When I am logged in' do
        before { login_as FactoryBot.create(:user, role: 0) }

        specify 'I can add a new review' do
            visit '/reviews'
            click_on 'New Review'
            expect(page).to have_content 'Add your review'
            fill_in 'Body', with: 'I absolutely love this website, would recommend to anyone.'
            click_on 'Save'
            expect(page).to have_content 'Review was successfully created.'
        end
    end
end