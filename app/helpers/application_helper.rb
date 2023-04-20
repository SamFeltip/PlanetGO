# frozen_string_literal: true

module ApplicationHelper
end

def additional_javascript(name)
  content_for :additional_javascript, "#{content_for?(:additional_javascript) ? ' ' : ''}#{name}"
end

def additional_stylesheet(name)
  content_for :additional_stylesheet, "#{content_for?(:additional_stylesheet) ? ' ' : ''}#{name}"
end
