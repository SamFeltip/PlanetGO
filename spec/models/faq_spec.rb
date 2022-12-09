# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :string
#  answered   :boolean          default(FALSE)
#  clicks     :integer          default(0)
#  displayed  :boolean          default(FALSE)
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Faq, type: :model do
  context 'When there are submitted FAQs' do
    before { @faq1 = FactoryBot.create(:faq, question: 'Where do I sign up?', answer: 'Thats simple, on the sign up page', answered: true, displayed: true) }
    before { @faq2 = FactoryBot.create(:faq, question: 'How much does it cost?', answer: 'Go check out our pricing options on the pricing page.', answered: true, displayed: true) }

    context 'When I click on a FAQ' do
      #specify 'the click counter is incremented' do
       # visit 'faqs'
       # click 'show'
      #end.to change(@faq1, :clicks)
    end
    context 'When I like an FAQ' do
      specify 'the like counter is incremented' do
        #how?
      end
    end
  end
end
