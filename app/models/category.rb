# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  has_many :category_interests, dependent: :destroy
  has_many :users, through: :category_interests

  after_create :add_users

  def liked_count
    where_interest_count(1) * 100 / category_interests.count
  end

  def indifferent_count
    where_interest_count(0) * 100 / category_interests.count
  end

  def disliked_count
    where_interest_count(-1) * 100 / category_interests.count
  end

  def where_interest_count(rating)
    score = 0.00
    category_interests.find_each do |category_interest|
      score += 1 if category_interest.interest == rating
    end
    score
  end

  private

  def add_users
    User.all.find_each do |u|
      # Only needed for commercial users and admins for management purposes
      users << u if u.commercial || u.admin?
    end
  end
end
