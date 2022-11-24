# == Schema Information
#
# Table name: pricings
#
#  id          :bigint           not null, primary key
#  description :string
#  price       :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Pricing, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
