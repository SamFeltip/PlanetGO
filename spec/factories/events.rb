# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                      :bigint           not null, primary key
#  address_line1           :string
#  address_line2           :string
#  approved                :boolean
#  cached_votes_down       :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_total      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  colour                  :integer
#  description             :text
#  latitude                :float
#  longitude               :float
#  name                    :string
#  postcode                :string
#  time_of_event           :datetime
#  town                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  category_id             :bigint
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_events_on_category_id  (category_id)
#  index_events_on_latitude     (latitude)
#  index_events_on_longitude    (longitude)
#  index_events_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :event do
    name { 'Live Music at The Jazz Club' }
    address_line1 { '104 West Street' }
    town { 'Sheffield' }
    postcode { 'S1 4EP' }
    # rubocop:disable Layout/LineLength
    description do
      "If you love jazz music, you won't want to miss this event. The Jazz Club is hosting a night of live music featuring some of the best local musicians. With a relaxed and intimate atmosphere, this is the perfect way to enjoy some great music and unwind after a long week."
    end
    # rubocop:enable Layout/LineLength
    category_id { Category.where(name: 'Music').first_or_create.id }
    user

    factory :event_with_likes do
      after(:create) do |event|
        user_list = create_list(:user, 25)
        user_list.each do |user|
          event.liked_by user
        end
      end
    end
  end
end
