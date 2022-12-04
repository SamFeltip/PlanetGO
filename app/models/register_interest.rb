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
class RegisterInterest < ApplicationRecord
    validates :email, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
end
