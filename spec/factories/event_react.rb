#  id         :bigint           not null, primary key
#  status     :integer          default("like"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  user_id    :bigint           not null
#
FactoryBot.define do
  factory :event_react do
    event_id { Event.find_by_sql("SELECT * FROM events ORDER BY random() LIMIT 1").first.id }
    user_id { User.find_by_sql("SELECT * FROM users ORDER BY random() LIMIT 1").first.id }
    status { EventReact.statuses[:like] }
  end
end