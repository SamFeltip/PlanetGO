# frozen_string_literal: true

# == Schema Information
#
# Table name: availabilities
#
#  id         :bigint           not null, primary key
#  end_time   :datetime
#  start_time :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_availabilities_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :availability do
    start_time { '1970-01-05 15:00:00' }
    end_time { '1970-01-05 18:15:00' }
    user { create(:user) }
  end
end
