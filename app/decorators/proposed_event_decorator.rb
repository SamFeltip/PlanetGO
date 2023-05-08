# frozen_string_literal: true

class ProposedEventDecorator < ApplicationDecorator
  delegate_all

  def proposed_datetime(compact: true)
    return 'No time selected' if object.proposed_datetime.nil?
    return object.event.decorate.display_time if object.event.time_of_event.present?

    return object.proposed_datetime.strftime('%b %d, %H:%M') if compact

    object.proposed_datetime.strftime('%b %d, %H:%M')
  end

  def vote_likes
    "#{votes_for.size} likes"
  end
end
