# frozen_string_literal: true

module OutingsHelper
  def remake_calendar(outing)
    calendar_start_date = Time.zone.at(342_000).to_date
    participants = Participant.where(outing_id: outing.id)
    peoples_availabilities = []
    participants.each do |participant|
      peoples_availabilities.append(Availability.where(user_id: participant.user_id))
    end

    good_start_datetime = outing.good_start_datetimes

    [calendar_start_date, peoples_availabilities, good_start_datetime]
  end
end
