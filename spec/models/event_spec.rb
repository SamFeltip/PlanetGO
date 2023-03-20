# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  approved      :boolean
#  category      :integer
#  description   :text
#  name          :string
#  time_of_event :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Event do
  # pending "add some examples to (or delete) #{__FILE__}"
  context 'viewing events' do
    describe 'a user can view all open events' do
      it 'shows the titles of events' do
      end

      describe 'likes' do
        it 'shows the likes of an event' do
        end

        it 'shows a friend has liked an event, if there is one to show' do
        end
      end

      describe 'when searching and filtering' do
        it 'lets a user search for events by title' do
        end

        it 'lets a user filter events by tags' do
        end
      end
    end

    describe 'when a user views a particular event' do
      it "let the user see event's title" do
      end

      it "let the user see event's location" do
      end

      it "let the user see event's tags" do
      end

      it "let the user see event's description" do
      end

      it 'let the user see events likes' do
      end
    end
  end

  context 'when submitting events for approval' do
    context 'when an advertiser logs in' do
      describe 'when advertisers submit events for approval' do
        it 'sends an event publicity request to admins' do
        end

        it 'lets admins view the publicity request' do
        end

        it 'doesnt let advertisers approve their own events' do
        end
      end
    end
  end

  context 'when approving events' do
    context 'when an admin logs in' do
      it 'lets admins view all pending event publicity' do
      end

      it 'lets admins accept an event for publicity' do
      end

      it 'lets admins reject an event for publicity' do
      end
    end
  end

  context 'changing events' do
    context 'when admins change the details of events' do
      it 'lets admins change the title of an event' do
      end
    end
  end
end
