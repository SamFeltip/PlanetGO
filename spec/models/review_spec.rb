# == Schema Information
#
# Table name: reviews
#
#  id                    :bigint           not null, primary key
#  body                  :text
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
  # pending "add some examples to (or delete) #{__FILE__}"

  before :each do
    @user = create(
              :user,
              id: 1,
              email: "sfelton1@sheffield.ac.uk"
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
      is_on_landing_page: true,
    )

  end

  describe '#get_above_landing_page_review' do

    it "get review" do
      expect(@review3.get_above_landing_page_review).to eq(@review1)
      expect(@review4.get_above_landing_page_review).to eq(@review3)
    end
  end
    # describe "get the review above self on the landing page" do
    # end


end
