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
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invite_token           :string
#  invited_by_type        :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  latitude               :float
#  locked_at              :datetime
#  longitude              :float
#  postcode               :string
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
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_latitude              (latitude)
#  index_users_on_longitude             (longitude)
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :events, dependent: :restrict_with_error
  has_many :outings, class_name: 'Outing', through: :participants
  has_many :category_interests, dependent: :destroy
  has_many :categories, through: :category_interests
  has_many :availabilities, dependent: :destroy

  validates :postcode, length: { maximum: 8 }, allow_blank: true, format: { with: /\A([A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}|GIR ?0A{2})\z/ }

  after_validation :geocode, if: ->(obj) { obj.postcode.present? and obj.postcode_changed? }
  after_create :add_categories
  acts_as_voter
  followability

  geocoded_by :postcode

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :secure_validatable,
         :lockable, :trackable
  devise :pwned_password unless Rails.env.test?

  scope :exclude_current_user, ->(current_user_id) { where.not(id: current_user_id) }
  scope :by_full_name, ->(full_name) { where('lower(full_name) LIKE ?', "%#{full_name.downcase}%") }

  self.per_page = 15

  enum role: {
    user: 0,
    reporter: 1,
    admin: 2,
    advertiser: 3
  }

  def liked_events
    Event.where(id: EventReact.select(:event_id).where(user_id: id)).where(approved: true)
  end

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

  def likes
    EventReact.where(user_id: id)
  end

  def liked(event)
    !likes.where(event_id: event.id).empty?
  end

  def event_reaction(event)
    reactions = EventReact.where(user_id: id, event_id: event.id)
    return if reactions.empty?

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
    event_list = event_list.where.not(id: ProposedEvent.select(:event_id).where(outing_id: outing.id)).limit(3) if outing

    event_list
  end

  def final_events
    local_events || most_liked_events
  end

  def most_liked_events
    Event.order_by_likes.limit(3)
  end

  def local_events
    postcode.present? ? Event.near("#{postcode}, UK", 10).limit(3) : nil
  end

  private

  def add_categories
    # Only needed for commercial users
    return unless commercial

    Category.all.find_each { |c| categories << c }
  end
end
