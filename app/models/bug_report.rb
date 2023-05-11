# frozen_string_literal: true

# == Schema Information
#
# Table name: bug_reports
#
#  id          :bigint           not null, primary key
#  category    :integer
#  description :text
#  resolved    :boolean          default(FALSE)
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_bug_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class BugReport < ApplicationRecord
  belongs_to :user
  has_one_attached :evidence
  has_many :comments, dependent: :destroy

  default_scope { includes(:evidence_attachment) }
  scope :search, ->(query) { where('title LIKE ? OR description LIKE ?', "%#{query}%", "%#{query}%") }
  scope :by_category, ->(category) { where(category:) }

  enum category: {
    usability: 0,
    functionality: 1,
    visual: 2,
    performance: 3
  }

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :category, presence: true
  validate :evidence_image

  private

  def evidence_image
    return unless evidence.attached? && !evidence.image?

    errors.add(:evidence, 'must be an image')
  end
end
