# == Schema Information
#
# Table name: event_reacts
#
#  id         :bigint           not null, primary key
#  status     :integer          default("like"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_event_reacts_on_event_id  (event_id)
#  index_event_reacts_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#
class EventReact < ApplicationRecord

  belongs_to :user
  belongs_to :event

  enum status: {
    like: 0,
    dislike: 1
  }

  validates :status, presence: true


end
