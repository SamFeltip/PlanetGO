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
  has_many :participants
  has_many :users, class_name: "User", :through => :participants
  # has_many :events, :through => :

  def to_s
    self.name
  end

end
