# frozen_string_literal: true

# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :string
#  answered   :boolean          default(FALSE)
#  clicks     :integer          default(0)
#  displayed  :boolean          default(FALSE)
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Faq < ApplicationRecord
  validates :question, presence: true, length: { maximum: 500 }
  acts_as_votable

  def check_is_answered
    self.answered = true
  end

  def uncheck_is_answered
    self.answered = false
  end

  def check_is_displayed
    self.displayed = true
  end

  def uncheck_is_displayed
    self.displayed = false
  end

  def is_answered_icon
    if answered
      '%i.bi-tick'
    else
      '%i.bi-cross'
    end
  end

  def is_displayed_icon
    if displayed
      '%i.bi-tick'
    else
      '%i.bi-cross'
    end
  end
end
