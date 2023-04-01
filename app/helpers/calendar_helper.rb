# frozen_string_literal: true

module CalendarHelper
  def calculate_height(start_time, end_time)
    start_time_minutes = (start_time[0..1].to_i * 60) + start_time[3..4].to_i
    end_time_minutes = (end_time[0..1].to_i * 60) + end_time[3..4].to_i
    ((end_time_minutes - start_time_minutes).to_f / 30)
  end
end
