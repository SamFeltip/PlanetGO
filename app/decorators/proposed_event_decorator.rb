class ProposedEventDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def proposed_datetime(compact: true)
    return 'No time selected' if object.proposed_datetime.nil?

    if compact
      return object.proposed_datetime.strftime('%b %d, %I:%M')
    else
      object.proposed_datetime.strftime('%A %B %d, at %I:%M %p')
    end
  end

  def vote_likes
    "#{participant_reactions.where(reaction: 'like').count} votes"
  end

end


