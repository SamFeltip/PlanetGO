# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Faq', type: :request do
    context 'When there are submitted FAQs' do
        before { @faq1 = FactoryBot.create(:faq, question: 'Where do I sign up?', answer: 'Thats simple, on the sign up page', answered: true, displayed: true) }
        before { @faq2 = FactoryBot.create(:faq, question: 'How much does it cost?', answer: 'Go check out our pricing options on the pricing page.', answered: true, displayed: true) }

        context 'When I am not signed in' do
            specify 'I can see the FAQs' do
                visit 'faqs'
                expect(page).to have_content 'Where do I sign up?'
                expect(page).to have_content 'Thats simple, on the sign up page'
                expect(page).to have_content 'How much does it cost?'
                expect(page).to have_content 'Go check out our pricing options on the pricing page.'
            end  
            specify 'There is no option to delete an FAQ' do
                visit 'faqs'
                expect(page).not_to have_content 'Delete'
            end
            specify 'There is no option to edit an FAQ' do
                visit 'faqs'
                expect(page).not_to have_content 'Editing Faq'
            end
        end
        context 'When I am signed in as an admin' do
            before do
                @admin = FactoryBot.create(:user, role: 2)
                login_as @admin
            end
            specify 'I can delete the FAQs' do
                visit 'faqs'
                expect do
                    click_on 'Delete'
                end.to change(Faq, :count)
            end  
            specify 'I can edit the FAQs' do
                visit 'faqs'
                click_on 'Edit'
                expect(page).to have_content 'Editing Faq'
            end  
            specify 'I can show FAQ details' do
                visit 'faqs'
                click_on 'Show'
                expect(page).to have_content 'Faq details'
            end
        end
    end
end