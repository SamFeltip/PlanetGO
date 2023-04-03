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

  private

  def add_users
    User.all.find_each do |user|
      # Only needed for commercial users and admins for management purposes
      return unless user.commercial || user.admin?

      users << user
    end
  end
end
