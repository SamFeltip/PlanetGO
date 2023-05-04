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
require 'rails_helper'

RSpec.describe Comment do
  describe 'associations' do
    it { is_expected.to belong_to(:bug_report) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(1000) }
  end
end
