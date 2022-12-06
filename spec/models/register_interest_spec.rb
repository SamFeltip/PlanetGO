# == Schema Information
#
# Table name: register_interests
#
#  id              :bigint           not null, primary key
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pricing_id      :string
#  pricing_plan_id :string
#
require 'rails_helper'

RSpec.describe RegisterInterest, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
 
end
