# frozen_string_literal: true

# == Schema Information
#
# Table name: outings
#
#  id           :bigint           not null, primary key
#  date         :date
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
end
