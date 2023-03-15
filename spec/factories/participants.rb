# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  outing_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_participants_on_outing_id  (outing_id)
#  index_participants_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (outing_id => outings.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do

  factory :participant do
    sequence(:id)

    status { 1 }
    user
    outing
  end
end
