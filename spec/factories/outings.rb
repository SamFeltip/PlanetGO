# frozen_string_literal: true

# == Schema Information
#
# Table name: outings
#
#  id           :bigint           not null, primary key
#  date         :date
#  description  :text
#  invite_token :string
#  name         :string
#  outing_type  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  creator_id   :bigint           not null
#
# Indexes
#
#  index_outings_on_creator_id    (creator_id)
#  index_outings_on_invite_token  (invite_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
FactoryBot.define do
  factory :outing do
    name { 'My exciting adventure' }
    date { Time.zone.now }
    description { 'This is a really cool adventure, with all my friends!' }
    creator_id { create(:user).id }
    outing_type { :personal }

    after :create do |outing|
      create(:participant, user: outing.creator, outing:, status: Participant.statuses[:creator])
    end
  end
end
