# frozen_string_literal: true

# == Schema Information
#
# Table name: outings
#
#  id           :bigint           not null, primary key
#  date         :datetime
#  description  :text
#  invite_token :string
#  name         :string
#  outing_type  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  creator_id   :bigint           not null
#
# Indexes
#
#  index_outings_on_creator_id    (creator_id)
#  index_outings_on_invite_token  (invite_token) UNIQUE
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
  has_secure_token :invite_token

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

  def check_pending(current_user)
    return true if Participant.exists?(outing_id: id, user_id: current_user.id, status: 'pending')

    false
  end

  def to_param
    invite_token
  end

  # function that returns at least the top 3 best start times. A good analogy would be traversing a mountain range where all
  # the peaks are the start_times of people's availabilities and the troughs would be the end_times of people's availabilities
  # and the highest peak is a time from which the biggest number of people are available
  def good_start_datetimes
    start_times = availabilities.order(:start_time).select(:start_time)
    end_times = availabilities.order(:end_time).select(:end_time)
    availabilities_array = []
    people_available_counter = start_counter = end_counter = 0

    # While start array is not empty
    while start_counter != start_times.size
      next_start = start_times[start_counter].start_time
      next_end = end_times[end_counter].end_time

      # Used to check if multiple availabilities start/stop at the same time
      previous_time = 0

      # Check if next earliest time is the start or end of an availability (or both)
      if next_start == next_end
        start_counter += 1
        end_counter += 1
      elsif next_start < next_end
        people_available_counter, availabilities_array, next_start, start_counter, previous_time = increase_number_available(people_available_counter, availabilities_array,
                                                                                                                             next_start, start_counter, previous_time)
      else
        people_available_counter, availabilities_array, next_end, end_counter, previous_time = decrease_number_available(people_available_counter, availabilities_array,
                                                                                                                         next_end, end_counter, previous_time)
      end
    end

    # add all the remaining end_times in one go
    end_times[end_counter..].each do |_index|
      people_available_counter, availabilities_array, next_end, end_counter, previous_time = decrease_number_available(people_available_counter, availabilities_array,
                                                                                                                       next_end, end_counter, previous_time)
    end

    # sort in reverse order on the number of people available
    availabilities_array = availabilities_array.sort_by { |hash| hash[:people_available].to_i }.reverse!

    # return first three rows
    availabilities_array[0..2]
  end

  def increase_number_available(people_available_counter, availabilities_array, next_start, start_counter, previous_time)
    if next_start == previous_time
      availabilities_array[-1][:people_available] += 1
      people_available_counter += 1
    else
      people_available_counter += 1
      availabilities_array.append({ datetime: next_start, people_available: people_available_counter })
      previous_time = next_start
    end
    start_counter += 1
    [people_available_counter, availabilities_array, next_start, start_counter, previous_time]
  end

  def decrease_number_available(people_available_counter, availabilities_array, next_end, end_counter, previous_time)
    people_available_counter -= 1
    if next_end == previous_time
      people_available_counter.zero? ? availabilities_array.pop : availabilities_array[-1][:people_available] = people_available_counter
    else
      availabilities_array.append({ datetime: next_end, people_available: people_available_counter }) if people_available_counter != 0
      previous_time = next_end
    end
    end_counter += 1
    [people_available_counter, availabilities_array, next_end, end_counter, previous_time]
  end

  def first_proposed_event
    events.order(:time_of_event).first
  end
end
