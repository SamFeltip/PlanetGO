# frozen_string_literal: true

# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  outing_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_participants_on_outing_id  (outing_id)
#  index_participants_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (outing_id => outings.id)
#  fk_rails_...  (user_id => users.id)
#
class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :outing
  has_many :participant_reactions, dependent: :destroy

  enum status: {
    pending: 0,
    confirmed: 1,
    rejected: 2,
    creator: 3
  }

  def to_s
    "#{user} has been invited to #{outing}. Status: #{status}"
  end

  delegate :full_name, to: :user
end
