# == Schema Information
#
# Table name: reviews
#
#  id                    :bigint           not null, primary key
#  body                  :text
#  clicks                :integer          default(0)
#  is_on_landing_page    :boolean          default(FALSE)
#  landing_page_position :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :bigint
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
  validates :body, presence: true, length: { maximum: 2048 }
  acts_as_votable
  belongs_to :user

  after_create :set_landing_page_position

  # set the landing page position when the review is created.
  def set_landing_page_position
    self.update_columns(landing_page_position: id) if landing_page_position.nil?
  end

  # shows the first few characters of the review for previewing purposes
  def summary(characters)
    "#{self.body[0, characters]}..."
  end

  def to_s
    "#{self.user} says #{self.summary(30)}"
  end

  def created_date
    self.created_at.strftime("%e %B %Y")
  end

  def swap_landing_page_position(other_review)
    current_lp_pos = self.landing_page_position
    self.update_columns(landing_page_position: other_review.landing_page_position) unless other_review.nil? or other_review.landing_page_position.nil?

    current_lp_pos
  end

  def get_above_landing_page_review
    Review.where("landing_page_position < ? AND is_on_landing_page", self.landing_page_position).order(:landing_page_position).last
  end

  def get_below_landing_page_review
    Review.where("landing_page_position > ? AND is_on_landing_page", self.landing_page_position).order(:landing_page_position).first
  end

  # move the review up in the landing page
  def go_up
    above_review = self.get_above_landing_page_review
    Review.swap_landing_page_positions(self, above_review)
  end

  # move the review down in the landing page
  def go_down
    below_review = self.get_below_landing_page_review
    Review.swap_landing_page_positions(self, below_review)
  end

  def self.swap_landing_page_positions(review1, review2)
    new_lp_pos = review1.swap_landing_page_position(review2)
    unless review2.nil?
      review2.update_columns(landing_page_position: new_lp_pos) unless new_lp_pos.nil?
      end
  end

  def is_on_landing_page_icon
    if self.is_on_landing_page
      '%i.bi-tick'
    else
      '%i.bi-cross'
    end
  end
end
