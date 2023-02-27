# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe 'Reviews' do
  context 'When there are submitted reviews' do
    before { FactoryBot.create(:review, body: "I'm not a huge fan but it's an interesting idea.") }
    before { FactoryBot.create(:review, body: 'I absolutely love this website, would recommend to anyone.') }

    context 'When I am not logged in' do
      specify 'I can see existing reviews' do
        visit '/reviews'
        expect(page).to have_content 'Our Reviews'
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
      before { login_as FactoryBot.create(:user, role: 'user') }

      specify 'I can add a new review' do
        visit '/reviews'
        click_on 'New Review'
        expect(page).to have_content 'Add your review'
        fill_in 'Body', with: 'This is such a great website. A pleasure to use.'
        click_on 'Save'
        expect(page).to have_content 'Review was successfully created.'
        expect(page).to have_content 'This is such a great website. A pleasure to use.'
      end

      specify 'I cannot add an empty review' do
        visit '/reviews/new'
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end

      specify 'I cannot add a review over 2048 characters' do
        visit '/reviews/new'
        body = Faker::Lorem.characters(number: 2050)
        fill_in 'Body', with: body
        click_on 'Save'
        expect(page).to have_content 'Body is too long (maximum is 2048 characters)'
      end

      specify 'I can see number of likes a review has received' do
        visit '/reviews'
        click_on 'Read more', match: :first
        expect(page).to have_css('#likes', text: '0')
      end

      specify 'I can like a review' do
        visit '/reviews'
        click_on 'Read more', match: :first
        click_on 'Like'
        expect(page).to have_css('#likes', text: '1')
      end

      specify 'I can unlike a review I have liked' do
        visit '/reviews'
        click_on 'Read more', match: :first
        click_on 'Like'
        click_on 'Unlike'
        expect(page).to have_css('#likes', text: '0')
      end

      specify 'I cannot unlike a review I have not liked' do
        visit '/reviews'
        click_on 'Read more', match: :first
        expect(page).to have_no_content 'Unlike'
      end

      specify 'I cannot see Edit button for a review' do
        visit '/reviews'
        expect(page).to have_no_content 'Edit'
      end

      specify "I cannot see 'Is on landing page' field content on index page" do
        visit '/reviews'
        expect(page).to have_no_content 'Landing page'
      end

      specify "I cannot see 'Is on landing page:' field content on show page" do
        visit '/reviews'
        expect(page).to have_no_content 'Is on landing page:'
      end

      specify 'I cannot delete a review' do
        visit '/reviews'
        expect(page).to have_content 'I absolutely love this website, would recommend to anyone.'
        expect(page).to have_no_content 'Delete'
      end
    end

    context 'When I am logged in as an admin' do
      before { login_as FactoryBot.create(:user, email: 'admin@email.com', role: 'admin') }

      specify 'I can delete a review' do
        visit '/reviews'
        expect(page).to have_content 'I absolutely love this website, would recommend to anyone.'
        click_on 'Delete', match: :first
        expect(page).to have_content 'Review was successfully deleted.'
        expect(page).to have_no_content 'I absolutely love this website, would recommend to anyone.'
      end

      specify 'I can edit a review' do
        visit '/reviews'
        click_on 'Edit'
        expect(page).to have_content 'Editing Review'
      end

      specify 'I can set a review to be on landing page' do
        visit '/reviews'
        click_on 'Edit'
        check 'review_is_on_landing_page'
        click_on 'Save'
        expect(page).to have_content 'Review was successfully updated.'
        click_on 'Edit'
        expect(page).to have_checked_field 'review_is_on_landing_page'
      end
    end
  end
end
