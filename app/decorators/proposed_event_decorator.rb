# frozen_string_literal: true

class ProposedEventDecorator < ApplicationDecorator
  delegate_all

  def proposed_datetime(compact: true)
    return 'No time selected' if object.proposed_datetime.nil?

    return object.proposed_datetime.strftime('%b %d, %I:%M') if compact

    object.proposed_datetime.strftime('%A %B %d, at %I:%M %p')
  end

  def vote_likes
    "#{votes_for.size} likes"
  end
end
