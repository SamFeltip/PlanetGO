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
FactoryBot.define do
  factory :bug_report do
    title { 'Error message when submitting a form' }
    description do
      "When I try to submit the registration form, I get an error message that says 'Oops, something went wrong. Please try again later.'"
    end
    category { :functionality }
    resolved { false }
    user { create(:user) }
  end
end
