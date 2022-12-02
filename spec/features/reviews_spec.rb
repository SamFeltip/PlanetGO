require 'rails_helper'

RSpec.feature 'Reviews' do
    context 'When there are submitted reviews' do
        before { FactoryBot.create(:review, body: 'I absolutely love this website, would recommend to anyone.') }
        before { FactoryBot.create(:review, body: "I'm not a huge fan but it's an interesting idea.") }

        context 'When I am not logged in' do
            specify 'I can see existing reviews' do
                visit '/reviews'
                expect(page).to have_content 'Listing Reviews'
                expect(page).to have_content 'I absolutely love this website, would recommend to anyone.'
                expect(page).to have_content "I'm not a huge fan but it's an interesting idea."
            end

            specify 'I cannot add a new review' do
                visit '/reviews'
                click_on 'New Review'
                expect(page).to have_content 'You need to sign in or sign up before continuing.'
            end

            specify 'I cannot like a review' do
                visit '/reviews'
                click_on 'Read more', match: :first
                click_on 'Like'
                expect(page).to have_content 'You need to sign in or sign up before continuing.'
            end
        end

        context 'When I am logged in as a user' do
            before { login_as FactoryBot.create(:user, role: 0) }

            specify 'I can add a new review' do
                visit '/reviews'
                click_on 'New Review'
                expect(page).to have_content 'Add your review'
                fill_in 'Body', with: 'I absolutely love this website, would recommend to anyone.'
                click_on 'Save'
                expect(page).to have_content 'Review was successfully created.'
            end

            specify 'I can see number of likes a review has received' do
                visit '/reviews'
                click_on 'Read more', match: :first
                expect(page).to have_content '0'
            end

            specify 'I can like a review' do
                visit '/reviews'
                click_on 'Read more', match: :first
                click_on 'Like'
                expect(page).to have_content '1'
            end

            specify 'I can unlike a review I have liked' do
                visit '/reviews'
                click_on 'Read more', match: :first
                click_on 'Like'
                click_on 'Unlike'
                expect(page).to have_content '0'
            end

            specify 'I cannot unlike a review I have not liked' do
                visit '/reviews'
                click_on 'Read more', match: :first
                expect(page).to have_no_content 'Unlike'
            end

            specify 'I cannot delete a review' do
                visit '/reviews'
                expect(page).to have_content 'I absolutely love this website, would recommend to anyone.'
                expect(page).to have_no_content 'Delete'
            end
        end

        context 'When I am logged in as an admin' do
            before { login_as FactoryBot.create(:user, email: 'admin@email.com', role: 2) }

            specify 'I can delete a review' do
                visit '/reviews'
                expect(page).to have_content 'I absolutely love this website, would recommend to anyone.'
                click_on 'Delete'
                expect(page).to have_content 'Review was successfully deleted.'
                expect(page).to have_no_content 'I absolutely love this website, would recommend to anyone.'
            end
        end
    end
end