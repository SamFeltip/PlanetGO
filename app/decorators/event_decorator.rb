# frozen_string_literal: true

class EventDecorator < ApplicationDecorator
  delegate_all

  def display_description(length = 100)
    if object.description.length <= length
      object.description
    else
      # get the number of words in description which produces a string no longer than length
      output = ''
      word_count = 0
      while output.length < length
        word_count += 1
        output = object.description.split[..word_count].join(' ')
      end

      "#{output}..."
    end
  end

  def approved_desc
    if object.approved.nil?
      'pending approval'
    elsif object.approved
      'approved'
    else
      'event rejected<br/>Change the details to request re-evalutation'
    end
  end

  def display_time
    if object.time_of_event
      object.time_of_event.strftime('%d/%m/%Y %H:%M')
    else
      'any time'
    end
  end

  # TODO: make this actually get a friend and the like count of an event
  def likes(user, compressed: false)
    event_likes = object.likes

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

  def location
    if object.has_attribute?(:location)
      object.location
    else
      'location unknown'
    end
  end

  def approved_icon
    if object.approved.nil?
      'bi-question-circle'
    elsif object.approved
      'bi-tick'
    else
      'bi-x'
    end
  end

  def like_icon(user)
    user_liked = user.liked(object)

    if user_liked
      'bi-star-fill'
    else
      'bi-star'
    end
  end

  def colour
    if object.category_id
      object.category.colour
    else
      'bg-gray-200'
    end
  end

  def approved_colour
    if object.approved.nil?
      'purple'
    elsif object.approved
      'green'
    else
      'red'
    end
  end
end
