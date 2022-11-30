# == Schema Information
#
# Table name: register_interests
#
#  id         :bigint           not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pricing_id :string
#
class RegisterInterest < ApplicationRecord
end
