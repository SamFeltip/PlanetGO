# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                      :bigint           not null, primary key
#  address_line1           :string
#  address_line2           :string
#  approved                :boolean
#  cached_votes_down       :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_total      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  colour                  :integer
#  description             :text
#  latitude                :float
#  longitude               :float
#  name                    :string
#  postcode                :string
#  time_of_event           :datetime
#  town                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  category_id             :bigint
#  user_id                 :bigint           not null
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
  acts_as_votable

  scope :approved, -> { where(approved: true) }
  scope :near, ->(postcode) { near("#{postcode}, UK", 5) }

  scope :restaurants, -> { joins(:category).where(category: { name: 'restaurant' }) }
  scope :accommodations, -> { joins(:category).where(category: { name: 'accommodation' }) }

  scope :user_events, ->(user) { where(user_id: user.id) }
  scope :user_pending_events, ->(user) { user_events(user).where(approved: [nil, false]) }

  scope :pending_for_review, ->(user) { where(approved: [nil]).where.not(user_id: user.id) }
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

  self.per_page = 6

  enum colour: { red: 0, pink: 1, purple: 2, blue: 3, cyan: 4, aqua: 5, turquoise: 6, green: 7, lime: 8, yellow: 9, orange: 10, amber: 11 }

  def to_s
    "#{name} @ #{decorate.display_time}"
  end

  def creator
    user
  end

  def address
    if address_line2?
      [address_line1, address_line2, town, postcode].compact.join(', ')
    else
      [address_line1, town, postcode].compact.join(', ')
    end
  end
end
