# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  outing_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_participants_on_outing_id  (outing_id)
#  index_participants_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (outing_id => outings.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Participant, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  context "circumstances that create participants" do
    context "an outing has been created" do
      describe "when an outing is created" do

        it "creates a participant for the creator" do

        end

        it "the participant status is set to creator" do

        end
      end
    end

    context "the creator of an event invites a user to an outing" do

    end

  end

end
