# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  def image?
    # check if file exists in packs/images/event_images
    Rails.root.join('app', 'packs', 'images', 'event_images', "#{name.downcase}.png").exist?
  end

  def colour
    # use the name to create a random colour as a seed
    red_attr = name.bytes.sum % 100
    green_attr = name.bytes.sum % 220
    blue_attr = name.bytes.sum % 255

    # convert each to hex
    red = red_attr.to_s(16)
    green = green_attr.to_s(16)
    blue = blue_attr.to_s(16)

    # add leading 0 if needed
    red = "0#{red}" if red.length == 1
    green = "0#{green}" if green.length == 1
    blue = "0#{blue}" if blue.length == 1

    "##{red}#{green}#{blue}"
  end
end
