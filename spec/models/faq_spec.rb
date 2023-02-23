# frozen_string_literal: true

# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :string
#  answered   :boolean          default(FALSE)
#  displayed  :boolean          default(FALSE)
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Faq, type: :model do
  before do
    @faq1 = FactoryBot.create(:faq, question: 'Where do I sign up?', answer: 'Thats simple, on the sign up page',
                                    answered: true, displayed: true)
    @faq2 = FactoryBot.create(:faq, question: 'How much does it cost?',
                                    answer: 'Go check out our pricing options on the pricing page.', answered: false, displayed: false)
  end

  describe '#check_is_answered' do
    it 'Sets the FAQ answered status to true' do
      @faq2.check_is_answered
      expect(@faq2.answered).to eq true
    end
  end

  describe '#uncheck_is_answered' do
    it 'Sets the FAQ answered status to false' do
      @faq1.uncheck_is_answered
      expect(@faq1.answered).to eq false
    end
  end

  describe '#check_is_displayed' do
    it 'Displays the FAQ' do
      @faq2.check_is_displayed
      expect(@faq2.displayed).to eq true
    end
  end

  describe '#uncheck_is_displayed' do
    it 'Hides the FAQ' do
      @faq1.uncheck_is_displayed
      expect(@faq1.displayed).to eq false
    end
  end

  describe '#is_answered_icon' do
    it 'Returns the tick icon when answered' do
      expect(@faq1.is_answered_icon).to eq '%i.bi-tick'
    end

    it 'Returns the cross icon when not answered' do
      expect(@faq2.is_answered_icon).to eq '%i.bi-cross'
    end
  end

  describe '#is_displayed_icon' do
    it 'Returns the tick icon when displayed' do
      expect(@faq1.is_displayed_icon).to eq '%i.bi-tick'
    end

    it 'Returns the cross icon when not displayed' do
      expect(@faq2.is_answered_icon).to eq '%i.bi-cross'
    end
  end
end
