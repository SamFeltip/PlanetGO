# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  approved      :boolean
#  category      :integer
#  description   :text
#  name          :string
#  time_of_event :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_events_on_user_id  (user_id)
#
# Foreign Keys
#
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

  has_many :event_reacts, dependent: :destroy

  enum category: {
    bar: 0,
    restaurant: 1,
    theatre: 2,
    music: 3,
    sports: 4
  }

  def likes
    EventReact.where(event_id: id, status: EventReact.statuses[:like])
  end

  # TODO: make this actually get a friend and the like count of an event
  def display_likes(user, compressed: false)
    event_likes = likes

    user_liked = user.liked(self)

    if compressed

      return 'liked' if user_liked

      return "#{event_likes.count} likes"

    end

    friend = nil
    if event_likes.count.positive?
      # TODO: get random friend
      friend = event_likes.first.user
    end

    # return string to display

    return "liked by me and #{event_likes.count - 1} others" if user_liked

    if friend
      "liked by #{friend} and #{event_likes.count - 1} others"
    else
      "#{event_likes.count} likes"
    end
  end

  def display_location
    if has_attribute?(:location)
      location
    else
      'location unknown'
    end
  end

  def like_icon(user)
    user_liked = user.liked(self)

    if user_liked
      'bi-star-fill'
    else
      'bi-star'
    end
  end

  def to_s
    "#{name} @ #{time_of_event}"
  end

  def approved_icon
    if approved.nil?
      'bi-question-circle'
    elsif approved
      'bi-tick'
    else
      'bi-x'
    end
  end

  def approved_colour
    if approved.nil?
      'purple'
    elsif approved
      'green'
    else
      'red'
    end
  end

  def approved_desc
    if approved.nil?
      'pending approval'
    elsif approved
      'approved'
    else
      'event rejected<br/>Change the details to request re-evalutation'
    end
  end

  def creator
    user
  end

  def self.my_pending_events(user)
    Event.where(user_id: user.id).where.not(approved: true)
  end

  def self.other_users_pending_events(user)
    Event.where.not(user_id: user.id).where.not(approved: true)
  end
end
