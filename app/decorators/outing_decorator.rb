# frozen_string_literal: true

class OutingDecorator < ApplicationDecorator
  delegate_all
  def display_date
    if object.date
      object.date.strftime('%b %d, %H:%M')
    else
      'starting time TBD'
    end
  end
end
