require 'rails_helper'

RSpec.feature 'Pricing' do
    context 'When a user accesses the pricings page' do
        specify 'I can see the exisiting pricing plans' do
            visit 'pricings'
            expect(page).to have_content 'Basic'
            expect(page).to have_content 'Features:'
            expect(page).to have_content 'Premium'
            expect(page).to have_content 'Premium+'
        end
    end
end