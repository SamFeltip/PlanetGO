# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  full_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user")
#  sign_in_count          :integer          default(0), not null
#  suspended              :boolean          default(FALSE)
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do


  let!(:creator_user) { create(:user, email: 'testemail@email.com') }

  let!(:past_outing_1) {
    create(
      :outing,
      name: 'past outing 1',
      creator_id: creator_user.id,
      date: Time.now - 1.day
    )
  }

  let!(:past_outing_2) {
    create(
      :outing,
      name: 'past outing 2',
      creator_id: creator_user.id,
      date: Time.now - 1.week
    )
  }

  let!(:future_outing_1) { create(
    :outing,
    name: 'future outing 1',
    creator_id: creator_user.id,
    date: Time.now + 1.day
  ) }

  let!(:future_outing_2) { create(
    :outing,
    name: 'future outing 2',
    creator_id: creator_user.id,
    date: Time.now + 1.week
  ) }


  it 'Returns the name when converted to a string' do
    expect(creator_user.to_s).to eq 'John Smith'
  end

  it 'Returns the prefix of an email' do
    expect(creator_user.email_prefix).to eq 'testemail'
  end

  describe '#commercial' do
    it 'Returns true if the user is of role user or advertiser' do
      user = create(:user, role: 'user')
      expect(user.commercial).to be true
    end

    it 'Returns false if the user is of role admin or reporter' do
      user = create(:user, role: 'reporter')
      expect(user.commercial).to be false
    end
  end

  it "should show future outings" do
    expect(future_outing_1.date).to eq(Date.today + 1.day)
  end

  describe '#future_outings' do
    it 'returns all outings in the future' do
      expect(creator_user.future_outings).to include(future_outing_1)
      expect(creator_user.future_outings).to include(future_outing_2)
    end

    it 'doesnt return outings in the past' do
      expect(creator_user.future_outings).not_to include(past_outing_1)
      expect(creator_user.future_outings).not_to include(past_outing_2)
    end
  end



end
