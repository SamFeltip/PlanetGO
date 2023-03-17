# == Schema Information
#
# Table name: outings
#
#  id               :bigint           not null, primary key
#  date             :date
#  description      :text
#  invitation_token :bigint
#  name             :string
#  outing_type      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  creator_id       :bigint           not null
#
# Indexes
#
#  index_outings_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
FactoryBot.define do
  factory :outing do

    name { "My exciting adventure" }
    date { Time.now }
    description { "This is a really cool adventure, with all my friends!" }
    creator {create(:user)}

    after :create do |outing|
      # creator = create(:user)
      create(:participant, user: outing.creator, outing: outing, status: Participant.statuses[:creator])
    end

    # participant {association :participant, status: "creator" }
  end
end
