# frozen_string_literal: true

class EventDecorator < ApplicationDecorator
  delegate_all

  def display_description(length = 100)
    if object.description.length <= length
      object.description
    else

      output = ''
      word_count = 0

      # as long as the output is less than length, add another word
      while object.description.split[..word_count].join(' ').length < length
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

  def likes(current_user: nil, compressed: false, current_user_liked: false)
    # get all like objects for this event
    event_likes = object.likes

    # if no user is given, just return the number of likes
    return "#{event_likes.count} likes" if current_user.nil?

    # if we want a shorter string
    if compressed
      return 'liked' if current_user_liked

      return "#{event_likes.count} likes"
    end

    # produces the 'and x other(s)' string
    and_others_string = "and #{event_likes.count - 1} other#{event_likes.count - 1 == 1 ? '' : 's'}"

    # returns early if the current user has already liked the string
    return "liked by you #{and_others_string}" if current_user_liked

    # if the user hasn't liked this event, use a random friend to convince them to like the event
    random_friend = current_user.get_random_friend(event: object)

    if random_friend
      "liked by #{random_friend} #{and_others_string}"
    else
      "#{event_likes.count} like#{event_likes.count == 1 ? '' : 's'}"
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
      'bi-check-circle'
    else
      'bi-x'
    end
  end

  def like_icon(current_user_liked)
    if current_user_liked
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
