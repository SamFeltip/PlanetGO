# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  content       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  bug_report_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_comments_on_bug_report_id  (bug_report_id)
#  index_comments_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (bug_report_id => bug_reports.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :bug_report
  belongs_to :user

  validates :content, presence: true, length: { maximum: 1000 }
end
