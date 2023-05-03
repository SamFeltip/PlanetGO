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
require 'rails_helper'

RSpec.describe BugReport do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(100) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_most(1000) }
    it { is_expected.to validate_presence_of(:category) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:category).with_values(usability: 0, functionality: 1, visual: 2, performance: 3) }
  end
end
