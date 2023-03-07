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
  after_initialize do |user|
    @creator_participant = self.participants.build(
      status: "creator"
    )
  end

  def to_s
    self.name
  end

  def time_status
    (Date.today - self.date) > 0 ? "future" : "past"
  end

  def self.future_outings
    outings = Outing.all
    future_outings = Outing.none
    outings.each do |outing|
      if outing.time_status == "future"
        future_outings = future_outings.or(Outing.where(:id => outing.id))
      end
    end

    future_outings

  end
end
