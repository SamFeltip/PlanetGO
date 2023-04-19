# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  approved      :boolean
#  description   :text
#  name          :string
#  time_of_event :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :bigint
#  user_id       :bigint           not null
#
# Indexes
#
#  index_events_on_category_id  (category_id)
#  index_events_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :event do
    category_id { Category.where(name: 'Sport').first_or_create.id }
    name { 'Disco' }
    time_of_event { '2023-02-24' }
    description { 'Come to the disco for fun vibes' }
  end
end
