# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RegisterInterest' do
  context 'When a user registers their interest', type: :request do
    before { @interest1 = FactoryBot.create(:register_interest, email: 'email1@gmail.com', pricing_id: 'basic') }
    before { @interest2 = FactoryBot.create(:register_interest, email: 'email2@gmail.com', pricing_id: 'premium') }
    before { @interest3 = FactoryBot.create(:register_interest, email: 'email3@gmail.com', pricing_id: 'premium_plus') }

    context 'When I am signed in as an administrator' do
      before do
        @admin = FactoryBot.create(:user, role: 2)
        login_as @admin
      end

      specify 'I can visit the register interests index page' do
        visit 'pricings/3/register_interests'
        expect(page).to have_current_path '/pricings/3/register_interests'
      end

      context 'I am on the register interests index page' do
        before { visit 'pricings/3/register_interests' }

        specify 'I can see existing interests' do
          expect(page).to have_content 'email1@gmail.com'
          expect(page).to have_content 'basic'
          expect(page).to have_content 'email2@gmail.com'
          expect(page).to have_content 'premium'
          expect(page).to have_content 'email3@gmail.com'
          expect(page).to have_content 'premium_plus'
        end

        specify 'I can delete an existing interest' do
          visit 'pricings/3/register_interests'
          expect do
            click_on 'Destroy'
          end.to change(RegisterInterest, :count)
        end
      end
    end

    context 'When I am not signed in' do
      specify 'I can register an interest' do
        expect do
          visit 'pricings/3/register_interests/new'
          fill_in 'Email', with: 'samplemail@emailserver.com'
          click_on 'Save'
        end.to change(RegisterInterest, :count)
      end

      specify 'I am not allowed access to others interest' do
        visit 'pricings/3/register_interests'
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      specify 'I cannot delete a registered interest' do
        expect do
          delete pricing_register_interest_path(@interest1.pricing_id, @interest1)
        end.not_to change(RegisterInterest, :count)
      end
    end

    context 'When I am signed in as a user' do
      before do
        @user = FactoryBot.create(:user, role: 0)
        login_as @user
      end

      specify 'I can register an interest' do
        expect do
          visit 'pricings/3/register_interests/new'
          fill_in 'Email', with: @user.email
          click_on 'Save'
        end.to change(RegisterInterest, :count)
      end

      specify 'I am not allowed access to others interest' do
        visit 'pricings/3/register_interests'
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot delete a registered interest' do
        expect do
          delete pricing_register_interest_path(@interest1.pricing_id, @interest1)
        end.not_to change(RegisterInterest, :count)
      end
    end

    context 'When I am signed in as a reporter' do
      before do
        @reporter = FactoryBot.create(:user, role: 1)
        login_as @reporter
      end

      specify 'I am not allowed access to others interest' do
        visit 'pricings/3/register_interests'
        expect(page).to have_content 'You are not authorized to access this page.'
      end

      specify 'I cannot delete a registered interest' do
        expect do
          delete pricing_register_interest_path(@interest1.pricing_id, @interest1)
        end.not_to change(RegisterInterest, :count)
      end
    end

    specify 'When email is invalid user should get an error' do
      visit '/pricings/basic/register_interests/new'
      @interest = RegisterInterest.new(email: 'email@gmail.com', pricing_id: 'basic')
      assert @interest.save
    end

    # email should follow format text@more_text
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
