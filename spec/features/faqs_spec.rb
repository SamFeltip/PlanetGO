# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Faq', type: :request do
  context 'When there are submitted FAQs & I am on the FAQ page' do
    before do
      @faq1 = FactoryBot.create(:faq, question: 'Where do I sign up?', answer: 'Thats simple, on the sign up page',
                                      answered: true, displayed: true)
      @faq2 = FactoryBot.create(:faq, question: 'How much does it cost?',
                                      answer: 'Go check out our pricing options on the pricing page.', answered: true, displayed: true)
      @faq3 = FactoryBot.create(:faq, question: 'I am hidden?',
                                      answer: 'Lets hope so', answered: true, displayed: false)
      visit 'faqs'
    end

    context 'When I am not signed in' do
      specify 'I can see the FAQs' do
        expect(page).to have_content 'Where do I sign up?'
        expect(page).to have_content 'Thats simple, on the sign up page'
        expect(page).to have_content 'How much does it cost?'
        expect(page).to have_content 'Go check out our pricing options on the pricing page.'
      end

      specify 'I cannot see a hidden FAQ' do
        expect(page).not_to have_content 'Am I hidden?'
      end

      specify 'There is no option to delete an FAQ' do
        expect(page).not_to have_content 'Delete'
      end

      specify 'There is no option to edit an FAQ' do
        expect(page).not_to have_content 'Editing Faq'
      end
    end

    context 'When I am logged in as a user' do
      before do
        @user = FactoryBot.create(:user, role: 0)
        login_as @user
        refresh
      end

      specify 'I can create an FAQ' do
        click_on 'New Faq'
        fill_in 'Question', with: 'Hello'
        expect do
          click_on 'Save'
        end.to change(Faq, :count)
      end

      specify 'I can like/unlike an FAQ' do
        visit faq_path(@faq1)
        click_on 'Like'
        visit faq_path(@faq1)
        expect(page).to have_content '1'
        click_on 'Unlike'
        visit faq_path(@faq1)
        expect(page).to have_content '0'
      end
    end

    context 'When I am signed in as an admin' do
      before do
        @admin = FactoryBot.create(:user, role: 2)
        login_as @admin
        refresh
      end

      specify 'I can view hidden FAQs' do
        expect(page).to have_content 'I am hidden?'
      end

      specify 'I can delete the FAQs' do
        expect do
          click_on 'Delete'
        end.to change(Faq, :count)
      end

      specify 'I can edit the FAQs' do
        click_on 'Edit'
        fill_in 'Question', with: 'Manufactured discourse'
        click_on 'Save'
        expect(page).to have_content 'Manufactured discourse'
      end

      specify 'I can show FAQ details' do
        click_on 'Show'
        expect(page).to have_content 'Faq details'
      end
    end
  end
end
