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

  enum category: {
    bar: 0,
    restaurant: 1,
    theatre: 2,
    music: 3,
    sports: 4
  }

  def likes
    rand(100)
  end

  #TODO make this actually get a friend and the like count of an event
  def display_likes(user)
    # TODO get likes of event

    # TODO get random friend who liked this event
    friend = User.where(id: rand(5)).first

    # return string to display
    if friend
      "liked by #{friend} and #{self.likes - 1} others"
    else
      "#{self.likes} likes"
    end
  end

  def display_location
    if self.has_attribute?(:location)
      self.location
    else
      "location unknown"
    end
  end

  def tags
    ["exciting", "good", "popular"]
  end

end
