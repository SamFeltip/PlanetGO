# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  address_line1 :string
#  address_line2 :string
#  approved      :boolean
#  description   :text
#  latitude      :float
#  longitude     :float
#  name          :string
#  postcode      :string
#  time_of_event :datetime
#  town          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :bigint
#  user_id       :bigint           not null
#
# Indexes
#
#  index_events_on_category_id  (category_id)
#  index_events_on_latitude     (latitude)
#  index_events_on_longitude    (longitude)
#  index_events_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

# Indexes
#
#  index_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :proposed_events, dependent: :destroy
  has_many :outings, through: :proposed_events
  has_many :event_reacts, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :address_line1, presence: true, length: { maximum: 255 }
  validates :town, presence: true, length: { maximum: 35 }
  validates :postcode, presence: true, length: { maximum: 8 }, format: { with: /\A([A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}|GIR ?0A{2})\z/ }
  validates :town, presence: true, length: { maximum: 35 }
  validates :description, presence: true, length: { maximum: 2048 }
  validates :category_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo

  geocoded_by :address
  after_validation :geocode

  def likes
    EventReact.where(event_id: id, status: EventReact.statuses[:like])
  end

  def to_s
    "#{name} @ #{time_of_event}"
  end

  def creator
    user
  end

  def user_interest(user)
    CategoryInterest.where(user_id: user.id, category_id:).first.interest
  end

  def image_path
    if category.image?
      "event_images/#{Category.find(category_id).name.downcase}.png"
    else
      'event_images/unknown.png'
    end
  end

  def address
    if address_line2?
      [address_line1, address_line2, town, postcode].compact.join(', ')
    else
      [address_line1, town, postcode].compact.join(', ')
    end
  end

  def self.my_pending_events(user)
    Event.where(user_id: user.id, approved: false).or(Event.where(user_id: user.id, approved: nil))
  end

  def self.other_users_pending_events(user)
    Event.where(approved: nil).where.not(user_id: user.id).or(Event.where(approved: false).where.not(user_id: user.id))
  end
end
