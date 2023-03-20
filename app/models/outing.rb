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

class Outing < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :users, class_name: 'User', through: :participants
  has_many :events, through: :proposed_events

  belongs_to :user, foreign_key: :creator_id

  enum outing_type: {
    personal: 0,
    open: 1
  }

  def to_s
    name
  end

  def time_status
    (Date.today - date).positive? ? 'past' : 'future'
  end

  def creator
    User.find(creator_id)
  end
end
