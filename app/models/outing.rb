# == Schema Information
#
# Table name: outings
#
#  id          :bigint           not null, primary key
#  date        :date
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Outing < ApplicationRecord
  enum status: {
    pending: 0,
    confirmed: 1,
    rejected: 2
  }

  def to_s
    self.name 
  end

end
