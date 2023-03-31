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

  def display_description(length = 100)

    if description.length <= length
      description
    else
      "#{description[0..length-3]}..."
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

  def image_path
    if category_id.nil?
      'event_images/unknown.png'
    else
      "event_images/#{Category.find(category_id).name.downcase}.png"
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
