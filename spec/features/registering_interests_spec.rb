require 'rails_helper'

RSpec.feature 'RegisterInterest' do
    context 'When a user registers their interest' do
        before { FactoryBot.create(:register_interest, email: 'email1@gmail.com', pricing_id: 'basic') }
        before { FactoryBot.create(:register_interest, email: 'email2@gmail.com', pricing_id: 'premium') }
        before { FactoryBot.create(:register_interest, email: 'email3@gmail.com', pricing_id: 'premium_plus') }

        specify 'I can see existing interests' do
            visit 'pricings/3/register_interests#'
            expect(page).to have_content 'email1@gmail.com'
            expect(page).to have_content 'basic'
            expect(page).to have_content 'email2@gmail.com'
            expect(page).to have_content 'premium'
            expect(page).to have_content 'email3@gmail.com'
            expect(page).to have_content 'premium_plus'
        end
        specify 'When email is invalid user should get an error' do
            visit '/pricings/basic/register_interests/new'
            @interest = RegisterInterest.new(email: 'email@gmail.com', pricing_id: 'basic')
            assert @interest.save
        end 
        #email should follow format text@more_text
        specify 'When email is invalid user should get an error' do
            visit '/pricings/basic/register_interests/new'
            @interest = RegisterInterest.new(email: 'email', pricing_id: 'basic')
            assert !@interest.save
        end 
        specify 'When pricing plan has not been selected user should get an error' do
            visit '/pricings/basic/register_interests/new'
            @interest = RegisterInterest.new(email: 'email@gmail.com')
            assert !@interest.save
        end 
    end
end