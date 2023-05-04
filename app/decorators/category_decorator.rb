# frozen_string_literal: true

class CategoryDecorator < Draper::Decorator
  delegate_all

  def to_s
    "#{object.symbol} #{object.name.pluralize}"
  end
end
