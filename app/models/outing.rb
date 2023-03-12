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
  has_many :events, :through => : proposed_events

  def to_s
    self.name
  end

  def time_status
    (Date.today - self.date) > 0 ? "past" : "future"
  end

  def self.future_outings(cu=nil)

    outings = Outing.all
    if cu
      outings = cu.my_outings
    end

    future_outings = Outing.none

    outings.each do |outing|
      if outing.time_status == "future"
        future_outings = future_outings.or(Outing.where(id: outing.id))
      end
    end

    future_outings

  end


  def self.past_outings(cu=nil)

    outings = Outing.all
    if cu
      outings = cu.my_outings
    end

    future_outings = Outing.none

    outings.each do |outing|
      if outing.time_status == "past"
        future_outings = future_outings.or(Outing.where(id: outing.id))
      end
    end

    future_outings

  end

  def creator
    Participant.where(outing_id: self.id, status: Participant.statuses[:creator]).first.user
  end
end
