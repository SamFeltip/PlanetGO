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

  default_scope { includes(:category) }
  scope :approved, -> { where(approved: true) }
  scope :near, -> { near("#{postcode}, UK", 5)}

  scope :restaurants, -> { joins(:category).where(category: { name: 'restaurant' }) }
  scope :accommodations, -> { joins(:category).where(category: { name: 'accommodation' }) }

  scope :order_by_likes, -> { left_joins(:event_reacts).group(:id).order('COUNT(event_reacts.id) DESC') }
  scope :user_events, ->(user) { where(user_id: user.id) }
  scope :pending_for_user, ->(user) { where(approved: [nil, false]).where.not(user_id: user.id) }
  scope :order_by_category_interest, lambda { |user|
    joins(:category)
      .joins("INNER JOIN category_interests ci ON ci.category_id = categories.id AND ci.user_id = #{user.id}")
      .order('ci.interest DESC')
  }

  validates :name, presence: true, length: { maximum: 100 }
  validates :address_line1, presence: true, length: { maximum: 255 }
  validates :town, presence: true, length: { maximum: 35 }
  validates :postcode, presence: true, length: { maximum: 8 }, format: { with: /\A([A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}|GIR ?0A{2})\z/ }
  validates :town, presence: true, length: { maximum: 35 }
  validates :description, presence: true, length: { maximum: 2048 }
  validates :category_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo

  geocoded_by :address
  after_validation :geocode, if: ->(obj) { %i[address_line1 address_line2 town postcode].any? { |attr| obj.public_send("#{attr}_changed?") } }

  self.per_page = 10

  def likes
    EventReact.where(event_id: id)
  end

  def to_s
    "#{name} @ #{time_of_event}"
  end

  def creator
    user
  end

  def image_path
    if category.image?
      "event_images/#{category.name.downcase}.webp"
    else
      'event_images/unknown.webp'
    end
  end

  def address
    if address_line2?
      [address_line1, address_line2, town, postcode].compact.join(', ')
    else
      [address_line1, town, postcode].compact.join(', ')
    end
  end
end
