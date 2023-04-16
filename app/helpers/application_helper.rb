# frozen_string_literal: true

module ApplicationHelper
end

def additional_javascript(name)
  content_for :additional_javascript, "#{content_for?(:additional_javascript) ? ' ' : ''}#{name}"
end

# q: what does content_for mean?
# a: https://apidock.com/rails/ActionView/Helpers/CaptureHelper/content_for
def additional_stylesheet(name)
  content_for :additional_stylesheet, "#{content_for?(:additional_stylesheet) ? ' ' : ''}#{name}"
end
