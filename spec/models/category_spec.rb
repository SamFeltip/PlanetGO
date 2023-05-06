# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  symbol     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Category do
  let!(:category1) { described_class.create(name: 'Bar') }
  let!(:user1) { create(:user, role: User.roles[:user]) }
  let!(:category_interest1) { category1.category_interests.first }

  describe '#add_users' do
    let!(:reporter1) { create(:user, role: User.roles[:reporter]) }

    it 'creates a link to commercial users through category interests' do
      expect(category1.users.find { |c| c == user1 }).not_to be_nil
    end

    it 'does not create a link to non-commercial users through category interests' do
      expect(category1.users.find { |c| c == reporter1 }).to be_nil
    end

    it 'has created a CategoryInterest between itself and the user' do
      expect(category1.category_interests.find { |ci| ci[:user_id] == user1.id }).not_to be_nil
    end
  end

  describe '#where_interest_count' do
    it 'finds the number of associated category interests where the interest is set to zero' do
      expect(category1.where_interest_count(0)).to eq 1
    end
  end

  describe '#liked_percent' do
    it 'finds the percentage of users who have liked the category' do
      category_interest1.update(interest: 1)
      expect(category1.liked_percent).to eq 100
    end
  end

  describe '#disliked_percent' do
    it 'finds the percentage of users who have disliked the category' do
      category_interest1.update(interest: -1)
      expect(category1.disliked_percent).to eq 100
    end
  end

  describe '#indifferent_percent' do
    it 'finds the percentage of users who have disliked the category' do
      category_interest1.update(interest: 0)
      expect(category1.indifferent_percent).to eq 100
    end
  end
end
