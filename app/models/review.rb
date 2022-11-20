# == Schema Information
#
# Table name: reviews
#
#  id                 :bigint           not null, primary key
#  body               :text
#  is_on_landing_page :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint
#
# Indexes
#
#  index_reviews_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Review < ApplicationRecord
  belongs_to :user

  # shows the first few characters of the review for previewing purposes
  def summary
    "#{self.body[0,18]}..."
  end

  def to_s
    "#{self.user} says #{self.summary}"
  end
end
