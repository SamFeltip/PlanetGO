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

    context 'when evidence is attached' do
      let(:bug_report) { create(:bug_report) }

      it 'validates that evidence is an image' do
        bug_report.evidence.attach(io: Rails.root.join('spec/fixtures/image.png').open, filename: 'image.png', content_type: 'image/png')
        expect(bug_report).to be_valid
      end

      it 'validates that evidence is not another file type' do
        bug_report.evidence.attach(io: Rails.root.join('spec/fixtures/document.pdf').open, filename: 'document.pdf', content_type: 'application/pdf')
        expect(bug_report).to be_invalid
        expect(bug_report.errors.full_messages).to include('Evidence must be an image')
      end
    end
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:category).with_values(usability: 0, functionality: 1, visual: 2, performance: 3) }
  end

  describe 'scopes' do
    let(:bug_report1) { create(:bug_report, title: 'Search test', description: 'Test search scope', category: :visual) }
    let(:bug_report2) { create(:bug_report, category: :functionality) }
    let(:bug_report3) { create(:bug_report, category: :usability) }

    describe '.search' do
      it 'returns bug reports with matching title or description' do
        expect(described_class.search('search')).to include(bug_report1)
        expect(described_class.search('search')).not_to include(bug_report2, bug_report3)
        expect(described_class.search('scope')).to include(bug_report1)
        expect(described_class.search('scope')).not_to include(bug_report2, bug_report3)
      end
    end

    describe '.by_category' do
      it 'returns bug reports with matching category' do
        expect(described_class.by_category(:functionality)).to include(bug_report2)
        expect(described_class.by_category(:functionality)).not_to include(bug_report1, bug_report3)
        expect(described_class.by_category(:usability)).to include(bug_report3)
        expect(described_class.by_category(:usability)).not_to include(bug_report1, bug_report2)
      end
    end
  end
end
