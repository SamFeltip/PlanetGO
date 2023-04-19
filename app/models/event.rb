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

# Indexes
#
#  index_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Event < ApplicationRecord
  belongs_to :user
  has_many :proposed_events, dependent: :destroy
  has_many :outings, through: :proposed_events

  has_many :event_reacts, dependent: :destroy

  belongs_to :category

  def likes
    EventReact.where(event_id: id, status: EventReact.statuses[:like])
  end

  def to_s
    "#{name} @ #{time_of_event}"
  end

  def creator
    user
  end

  def user_interest(user)
    CategoryInterest.where(user_id: user.id, category_id:).first.interest
  end

  def image_path
    if category.image?
      "event_images/#{Category.find(category_id).name.downcase}.png"
    else
      'event_images/unknown.png'
    end
  end

  def self.my_pending_events(user)
    # Event.where(user_id: user.id).where.not(approved: true)
    Event.where(user_id: user.id, approved: false).or(Event.where(user_id: user.id, approved: nil))
  end

  def self.other_users_pending_events(user)
    # Event.where.not(user_id: user.id).where.not(approved: true)
    Event.where(approved: nil).where.not(user_id: user.id).or(Event.where(approved: false).where.not(user_id: user.id))
  end
end
