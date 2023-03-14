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
class Event < ApplicationRecord

  belongs_to :user
  has_many :event_reacts

  enum category: {
    bar: 0,
    restaurant: 1,
    theatre: 2,
    music: 3,
    sports: 4
  }

  def likes
    EventReact.where(event_id: self.id, status: EventReact.statuses[:like])
  end

  #TODO make this actually get a friend and the like count of an event
  def display_likes(user, compressed=false)

    event_likes = self.likes


    user_liked = user.event_reaction(self) == "like"

    if compressed

      if user_liked
        return "liked"
      else
        return "#{event_likes.count} likes"
      end

    end

    friend = nil
    if event_likes.count > 0
      # TODO get random friend
      friend = event_likes.first.user
    end

    # return string to display

    if user_liked
      return "liked by yourself and #{event_likes.count - 1} others"
    end

    if friend
      "liked by #{friend} and #{event_likes.count - 1} others"
    else
      "#{event_likes.count} likes"
    end
  end

  def display_location
    if self.has_attribute?(:location)
      self.location
    else
      "location unknown"
    end
  end

  def like_icon(user)
    user_liked = user.event_reaction(self) == "like"

    if user_liked
      "bi-star-fill"
    else
      "bi-star"
    end

  end

  def tags
    ["exciting", "good", "popular"]
  end

  def to_s
    "#{self.name} @ #{self.time_of_event}"
  end
end
