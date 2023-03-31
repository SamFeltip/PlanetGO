# == Schema Information
#
# Table name: category_interests
#
#  id          :bigint           not null, primary key
#  interest    :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_category_interests_on_category_id  (category_id)
#  index_category_interests_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
class CategoryInterest < ApplicationRecord
  belongs_to :user
  belongs_to :category
end
