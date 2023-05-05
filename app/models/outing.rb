# frozen_string_literal: true

# == Schema Information
#
# Table name: outings
#
#  id               :bigint           not null, primary key
#  date             :date
#  description      :text
#  invitation_token :bigint
#  name             :string
#  outing_type      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  creator_id       :bigint           not null
#
# Indexes
#
#  index_outings_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

class Outing < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :users, class_name: 'User', through: :participants
  has_many :availabilities, class_name: 'Availability', through: :users

  belongs_to :user, foreign_key: :creator_id, inverse_of: false

  has_many :proposed_events, dependent: :destroy
  has_many :events, through: :proposed_events

  scope :order_soonest, -> { order(date: :asc) }

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 2048 }
  validates :outing_type, presence: true

  enum outing_type: {
    personal: 0,
    open: 1
  }

  def to_s
    name
  end

  def creator
    User.find(creator_id)
  end

  def accepted_participants(current_user)
    Participant.where(outing_id: id, status: Participant.statuses[:confirmed]).where.not(user_id: current_user.id)
  end

  def pending_participants(current_user)
    Participant.where(outing_id: id, status: Participant.statuses[:pending]).where.not(user_id: current_user.id)
  end

  def good_start_datetime
    start_times = availabilities.order(:start_time).select(:start_time)
    end_times = availabilities.order(:end_time).select(:end_time)

    array_of_availabilities = []
    people_available_counter = 0
    start_counter = 0
    end_counter = 0

    while (start_counter != start_times.size) && (end_counter != end_times.size)
      next_start = start_times[start_counter].start_time
      next_end = end_times[end_counter].end_time
      if next_start == next_end
        start_counter += 1
        end_counter += 1
        Rails.logger.debug 'incrementing end_counter'
        Rails.logger.debug end_counter
      elsif next_start < next_end
        people_available_counter += 1
        array_of_availabilities.append({ datetime: next_start, people_available: people_available_counter })
        start_counter += 1
      else
        people_available_counter -= 1
        array_of_availabilities.append({ datetime: next_end, people_available: people_available_counter }) if people_available_counter != 0
        end_counter += 1
        Rails.logger.debug 'incrementing end_counter'
        Rails.logger.debug end_counter
      end

      next unless start_counter == start_times.size

      stop_place = end_times.size - 1
      (end_counter..stop_place).each do |_index|
        people_available_counter -= 1
        array_of_availabilities.append({ datetime: end_times[end_counter].end_time, people_available: people_available_counter }) if people_available_counter != 0
        end_counter += 1
      end
    end

    array_of_availabilities = array_of_availabilities.sort_by { |hash| hash[:people_available].to_i }.reverse!

    # return first three rows or all if less than 3
    return array_of_availabilities[0..2] if array_of_availabilities.size > 3

    array_of_availabilities
  end
end
