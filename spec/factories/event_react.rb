# frozen_string_literal: true

#  id         :bigint           not null, primary key
#  status     :integer          default("like"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  user_id    :bigint           not null
#
FactoryBot.define do
  factory :event_react do
    event
    user
  end
end
