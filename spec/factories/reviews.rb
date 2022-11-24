# == Schema Information
#
# Table name: reviews
#
#  id                    :bigint           not null, primary key
#  body                  :text
#  is_on_landing_page    :boolean
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
FactoryBot.define do
  factory :review do
    body { "MyText" }
    user
  end
end
