# frozen_string_literal: true

class EventDecorator < ApplicationDecorator
  delegate_all

  def display_description(length = 100)
    if object.description.length <= length
      object.description
    else

      output = ''
      word_count = 0

      object.description.split.each do |word|
        break if (output + word).length > length

        output += "#{word} "
        word_count += 1
      end

      "#{output.strip}..."
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
      object.time_of_event.strftime('%b %d, %I:%M %p')
    else
      'any time'
    end
  end

  # returns a string describing who has liked this event and how many people there are,
  # using the current user to include friends names if they have liked it
  def likes(current_user: nil, compressed: false)
    current_user_liked = false
    current_user_liked = current_user.voted_up_on? self unless current_user.nil?

    # get all like objects for this event
    event_likes_count = object.votes_for.size

    # if no user is given, just return the number of likes
    return "#{event_likes_count} likes" if current_user.nil?

    # if we want a shorter string
    if compressed
      return 'liked' if current_user_liked

      return "#{event_likes_count} likes"
    end

    # produces the 'and x other(s)' string
    and_others_string = "and #{event_likes_count - 1} other#{event_likes_count - 1 == 1 ? '' : 's'}"

    # returns early if the current user has already liked the string
    return "liked by you #{and_others_string}" if current_user_liked

    # if the user hasn't liked this event, use a random friend to convince them to like the event
    random_friend = current_user.get_random_friend(event: object)

    if random_friend
      "liked by #{random_friend} #{and_others_string}"
    else
      "#{event_likes_count} like#{event_likes_count == 1 ? '' : 's'}"
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

  def like_icon(current_user)
    return 'bi-star' if current_user.nil?

    current_user_liked = current_user.voted_up_on?(event)
    if current_user_liked
      'bi-star-fill'
    else
      'bi-star'
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

  def map_image
    "https://api.mapbox.com/styles/v1/mapbox/light-v10/static/pin-s+ff0000(#{longitude},#{latitude})/#{longitude},#{latitude},10,0/300x200@2x?access_token=pk.eyJ1IjoicmFuZGludDI4IiwiYSI6ImNsaDQwN244MDBnYnEzY3Fnazc4NW14d2UifQ.jdlAkOv03e_XS165HrP2Vg"
  end
end
