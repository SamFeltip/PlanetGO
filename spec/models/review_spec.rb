# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id                    :bigint           not null, primary key
#  body                  :text
#  clicks                :integer          default(0)
#  is_on_landing_page    :boolean          default(FALSE)
#  landing_page_position :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :bigint
#
# Indexes
#
#  index_reviews_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Review, type: :model do
  before do
    @user = create(
      :user,
      id: 1,
      full_name: 'Sam Felton',
      email: 'sfelton1@sheffield.ac.uk'
    )

    @review1 = create(
      :review,
      id: 1,
      user_id:
        @user.id,
      body: 'review 1 body',
      is_on_landing_page: true,
      landing_page_position: 1
    )

    @review2 = create(
      :review,
      id: 2,
      user_id:
        @user.id,
      body: 'review 2 body',
      is_on_landing_page: false,
      landing_page_position: 2
    )

    @review3 = create(
      :review,
      id: 3,
      user_id:
        @user.id,
      body: 'review 3 body',
      is_on_landing_page: true,
      landing_page_position: 3
    )

    @review4 = create(
      :review,
      id: 4,
      user_id: @user.id,
      body: 'review 4 body',
      is_on_landing_page: true
    )

    @review5 = create(
      :review,
      id: 5,
      user_id: @user.id,
      body: 'review 5 body',
      is_on_landing_page: false,
      created_at: DateTime.new(2012, 8, 29, 22, 35, 0)
    )
  end

  describe '#to_s' do
    it 'Converts the review model to a string' do
      expect(@review1.to_s).to eq 'Sam Felton says review 1 body...'
    end
  end

  describe '#created_date' do
    it 'Returns an appropriately formatted date' do
      expect(@review5.created_date).to eq '29 August 2012'
    end
  end

  describe '#swap_landing_page_position' do
    it 'Changes landing page position to that of another review' do
      @review1.swap_landing_page_position(@review2)
      expect(@review1.landing_page_position).to eq 2
    end
  end

  describe '#shift_up' do
    it 'Moves the review up one position on the landing page' do
      @review2.shift_up
      expect(@review2.landing_page_position).to eq 1
    end

    it 'Moves the review up one position when already top review' do
      @review1.shift_up
      expect(@review1.landing_page_position).to eq 1
    end
  end

  describe '#shift_down' do
    it 'Moves the review down one position on the landing page' do
      @review2.shift_down
      expect(@review2.landing_page_position).to eq 3
    end

    it 'Moves the review down one position when already bottom' do
      @review4.shift_down
      expect(@review4.landing_page_position).to eq 4
    end
  end

  describe '#swap_landing_page_positions' do
    it 'Swaps the positions of two landin page reviews' do
      described_class.swap_landing_page_positions(@review1, @review3)
      expect(@review1.landing_page_position).to eq 3
      expect(@review3.landing_page_position).to eq 1
    end
  end

  describe '#get_above_landing_page_review' do
    it 'Get review' do
      expect(@review3.get_above_landing_page_review).to eq(@review1)
      expect(@review4.get_above_landing_page_review).to eq(@review3)
    end
  end

  describe '#is_on_landing_page_icon' do
    it 'Returns the correct icon for when on landing page' do
      expect(@review1.is_on_landing_page_icon).to eq '%i.bi-tick'
    end

    it 'Returns the correct icon for when not on landing page' do
      expect(@review5.is_on_landing_page_icon).to eq '%i.bi-cross'
    end
  end
end
