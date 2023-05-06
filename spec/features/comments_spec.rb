# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe 'Add comment from bug report show page' do
  let(:user) { create(:user) }
  let(:bug_report) { create(:bug_report, user:) }

  before do
    login_as(user)
    visit bug_report_path(bug_report)
  end

  it 'user adds a comment to a bug report' do
    fill_in 'comment[content]', with: 'This is a test comment.'
    click_button 'Comment'

    expect(page).to have_content('Comment created successfully.')
    expect(page).to have_content('This is a test comment.')
    expect(page).to have_content(user.full_name)
  end

  it 'user cannot add a comment longer than 1000 characters' do
    comment = Faker::Lorem.characters(number: 1001)
    fill_in 'comment[content]', with: comment
    click_button 'Comment'

    expect(page).to have_current_path(bug_report_path(bug_report))
    expect(page).to have_content('Content is too long (maximum is 1000 characters)')
    expect(page).not_to have_content(comment)
  end
end
