# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  full_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user")
#  sign_in_count          :integer          default(0), not null
#  suspended              :boolean          default(FALSE)
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :events, dependent: :restrict_with_error
  has_many :outings, class_name: 'Outing', through: :participants
  has_many :availabilities, dependent: :destroy

  acts_as_voter
  followability
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :secure_validatable,
         :pwned_password, :lockable, :trackable

  enum role: {
    user: 0,
    reporter: 1,
    admin: 2,
    advertiser: 3
  }

  def liked_events
    Event.where(id: EventReact.select(:event_id).where(user_id: id))
  end

  # this function is trying to get all outings this user has created
  # using a joiner with the participants table
  def my_outings
    Outing.where(creator_id: id)
  end

  def future_outings(creator = nil)
    outing_ids = Participant.where(user_id: id).pluck(:outing_id)
    outings = Outing.where(id: outing_ids)
    outings_future = outings.where('date > ?', Time.zone.today)

    outings_future = outings_future.where(creator_id: creator.id) if creator

    outings_future
  end

  def past_outings(creator = nil)
    outing_ids = Participant.where(user_id: id).pluck(:outing_id)
    outings = Outing.where(id: outing_ids)
    outings_past = outings.where('date <= ?', Time.zone.today)

    outings_past = outings_past.where(creator_id: creator.id) if creator

    outings_past
  end

  def to_s
    full_name
  end

  def initials
    full_name.split.map(&:first).join.upcase
  end

  def email_prefix
    email.split('@')[0]
  end

  def liked(event)
    EventReact.where(user_id: id, event_id: event.id, status: EventReact.statuses[:like]).count.positive?
  end

  def event_reaction(event)
    reactions = EventReact.where(user_id: id, event_id: event.id)
    return unless reactions.length.positive?

    reactions.first.status
  end

  def commercial
    %w[user advertiser].include? role
  end

  def not_invited_friends(outing)
    following.where.not(id: outing.participants.pluck(:user_id))
  end

  # get a random friend.
  # if an event is given, pick from a user who has liked this event
  def get_random_friend(event: nil)
    # if an event is given
    # rubocop made me do it like this :(
    friends = if event
                # get a list of all following users who have liked this event
                following.where(id: event.likes.pluck(:user_id))
              else
                following
              end

    return nil if friends.empty?

    # get a random friend from the list (we are not using .sample because offset works better on large datasets)
    friend_likes_count = friends.count
    random_offset = rand(friend_likes_count)
    # return offset friend
    friends.offset(random_offset).first
  end

  def recommended_events(outing: nil)
    # get all events the user has liked
    event_list = Event.where(id: EventReact.select(:event_id).where(user_id: id))

    # filter out all events in the outing, if it exists
    event_list = event_list.where.not(id: ProposedEvent.select(:event_id).where(outing_id: outing.id)) if outing

    event_list
  end

  # TODO: make these a restaurant and a hotel nearby
  def final_events
    Event.limit(2)
  end
end
