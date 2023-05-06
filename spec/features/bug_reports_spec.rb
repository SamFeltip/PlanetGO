# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BugReports' do
  let(:admin) { create(:user, role: :admin) }
  let(:user) { create(:user) }

  describe 'index page' do
    context 'when logged in as admin' do
      let!(:bug_report1) { create(:bug_report, user:, title: 'Bug 1', category: 'usability') }
      let!(:bug_report2) { create(:bug_report, user:, title: 'Bug 2', category: 'functionality') }
      let!(:bug_report3) { create(:bug_report, user:, title: 'Bug 3', category: 'visual') }

      before do
        login_as(admin)
        visit bug_reports_path
      end

      it 'displays all bug reports' do
        expect(page).to have_selector('.bug-report', count: 3)
      end

      it 'can delete a bug report' do
        within first('.bug-report') do
          click_link 'Delete'
        end
        expect(page).to have_content('Bug report was successfully deleted.')
        expect(page).to have_selector('.bug-report', count: 2)
      end

      it 'can edit a bug report' do
        within first('.bug-report') do
          click_link 'Edit'
        end
        fill_in 'Title', with: 'New title'
        click_button 'Submit'
        expect(page).to have_content('Bug report was successfully updated.')
        expect(page).to have_content('New title')
      end

      it 'can search by title or description' do
        fill_in 'search_query', with: 'Bug 1'
        click_on 'Search'

        expect(page).to have_content(bug_report1.title)
        expect(page).not_to have_content(bug_report2.title)
        expect(page).not_to have_content(bug_report3.title)
      end

      it 'can filter by category' do
        select 'usability', from: 'search[category]'
        click_on 'Search'

        expect(page).to have_content(bug_report1.title)
        expect(page).not_to have_content(bug_report2.title)
        expect(page).not_to have_content(bug_report3.title)
      end

      it 'can search by title or description and filter by category' do
        fill_in 'search_query', with: 'Bug'
        select 'usability', from: 'search[category]'
        click_on 'Search'

        expect(page).to have_content(bug_report1.title)
        expect(page).not_to have_content(bug_report2.title)
        expect(page).not_to have_content(bug_report3.title)
      end
    end

    context 'when logged in as user' do
      let!(:user_bug_report) { create(:bug_report, user:) }

      before do
        create(:bug_report, user: admin)
        login_as(user)
        visit bug_reports_path
      end

      it 'displays only user\'s bug reports' do
        expect(page).to have_selector('.bug-report', count: 1)
        expect(page).to have_content(user_bug_report.title)
      end

      it 'can delete own bug report' do
        within first('.bug-report') do
          click_link 'Delete'
        end
        expect(page).to have_content('Bug report was successfully deleted.')
        expect(page).not_to have_selector('.bug-report')
      end

      it 'can edit own bug report' do
        within first('.bug-report') do
          click_link 'Edit'
        end
        fill_in 'Title', with: 'New title'
        click_button 'Submit'
        expect(page).to have_content('Bug report was successfully updated.')
        expect(page).to have_content('New title')
      end
    end
  end

  describe 'show page' do
    let(:bug_report) { create(:bug_report) }

    context 'when logged in as admin' do
      before do
        login_as(admin)
        visit bug_report_path(bug_report)
      end

      it 'displays the bug report' do
        expect(page).to have_content(bug_report.title)
        expect(page).to have_content(bug_report.description)
        expect(page).to have_content(bug_report.category)
        expect(page).to have_content(bug_report.resolved)
        expect(page).to have_content(bug_report.user)
      end
    end

    context 'when logged in as user who submitted the bug report' do
      let(:user) { bug_report.user }

      before do
        login_as(user)
        visit bug_report_path(bug_report)
      end

      it 'displays the bug report' do
        expect(page).to have_content(bug_report.title)
        expect(page).to have_content(bug_report.description)
        expect(page).to have_content(bug_report.category)
        expect(page).to have_content(bug_report.resolved)
        expect(page).to have_content(bug_report.user)
      end
    end

    context 'when logged in as user who did not submit the bug report' do
      let(:user) { create(:user) }

      before do
        login_as(user)
        visit bug_report_path(bug_report)
      end

      it 'redirects to root' do
        expect(page).to have_current_path(root_path, ignore_query: true)
        expect(page).to have_content('You are not authorized to access this page.')
      end
    end
  end

  describe 'edit page' do
    let(:bug_report) { create(:bug_report) }

    context 'when logged in as admin' do
      before do
        login_as(admin)
        visit edit_bug_report_path(bug_report)
      end

      it 'displays the edit form' do
        expect(page).to have_content('Editing Bug Report')
        expect(page).to have_field('Title', with: bug_report.title)
        expect(page).to have_field('Description', with: bug_report.description)
        expect(page).to have_field('Category', with: bug_report.category)
        expect(page).to have_field('Resolved', checked: bug_report.resolved)
      end

      it 'updates the bug report' do
        new_title = 'New Title'
        new_description = 'New Description'
        new_category = 'usability'

        fill_in 'Title', with: new_title
        fill_in 'Description', with: new_description
        select new_category, from: 'Category'
        check 'Resolved'
        click_button 'Submit'

        expect(page).to have_current_path(bug_report_path(bug_report), ignore_query: true)
        expect(page).to have_content('Bug report was successfully updated.')
        expect(page).to have_content(new_title)
        expect(page).to have_content(new_description)
        expect(page).to have_content(new_category)
        expect(page).to have_content('true')
      end
    end

    context 'when logged in as user who submitted the bug report' do
      let(:user) { bug_report.user }

      before do
        login_as(user)
        visit edit_bug_report_path(bug_report)
      end

      it 'displays the edit form' do
        expect(page).to have_content('Editing Bug Report')
        expect(page).to have_field('Title', with: bug_report.title)
        expect(page).to have_field('Description', with: bug_report.description)
        expect(page).to have_field('Category', with: bug_report.category)
      end

      it 'updates the bug report' do
        new_title = 'New Title'
        new_description = 'New Description'
        new_category = 'usability'

        fill_in 'Title', with: new_title
        fill_in 'Description', with: new_description
        select new_category, from: 'Category'
        click_button 'Submit'

        expect(page).to have_current_path(bug_report_path(bug_report), ignore_query: true)
        expect(page).to have_content('Bug report was successfully updated.')
        expect(page).to have_content(new_title)
        expect(page).to have_content(new_description)
        expect(page).to have_content(new_category)
        expect(page).to have_content('false')
      end
    end

    context 'when logged in as user who did not submit the bug report' do
      let(:user) { create(:user) }

      before do
        login_as(user)
        visit edit_bug_report_path(bug_report)
      end

      it 'redirects to root' do
        expect(page).to have_current_path(root_path, ignore_query: true)
        expect(page).to have_content('You are not authorized to access this page.')
      end
    end
  end

  describe 'create page' do
    let(:user) { create(:user) }

    context 'when logged in as user' do
      before do
        login_as(user)
        visit new_bug_report_path
      end

      it 'allows to create a new bug report' do
        fill_in 'Title', with: 'Test bug report'
        fill_in 'Description', with: 'This is a test bug report'
        select 'performance', from: 'Category'
        attach_file 'Upload evidence', Rails.root.join('spec/fixtures/image.png')
        click_on 'Submit'

        expect(page).to have_content('Bug report was successfully created.')
        expect(page).to have_content('Test bug report')
        expect(page).to have_content('This is a test bug report')
        expect(page).to have_content('performance')
        expect(page).to have_content('false')
        expect(BugReport.last.evidence).to be_attached
      end
    end

    context 'when not logged in' do
      before { visit new_bug_report_path }

      it 'redirects to login page' do
        expect(page).to have_current_path(new_user_session_path, ignore_query: true)
        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
    end
  end
end
