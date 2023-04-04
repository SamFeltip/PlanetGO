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

RSpec.describe User do
  let!(:creator_user) { create(:user, full_name: 'John Smith', email: 'testemail@email.com') }

  let!(:past_outing1) do
    create(
      :outing,
      name: 'past outing 1',
      creator_id: creator_user.id,
      date: 1.day.ago
    )
  end

  let!(:past_outing2) do
    create(
      :outing,
      name: 'past outing 2',
      creator_id: creator_user.id,
      date: 1.week.ago
    )
  end

  let!(:future_outing1) do
    create(
      :outing,
      name: 'future outing 1',
      creator_id: creator_user.id,
      date: 1.day.from_now
    )
  end

  let!(:future_outing2) do
    create(
      :outing,
      name: 'future outing 2',
      creator_id: creator_user.id,
      date: 1.week.from_now
    )
  end

  it 'Returns the name when converted to a string' do
    expect(creator_user.to_s).to eq 'John Smith'
  end

  it 'Returns the prefix of an email' do
    expect(creator_user.email_prefix).to eq 'testemail'
  end

  describe '#add_categories' do
    let!(:category1) { Category.create(name: 'Bar') }
    let!(:user1) { create(:user, role: described_class.roles[:user]) }
    let!(:reporter1) { create(:user, role: described_class.roles[:reporter]) }

    it 'creates a link from commercial users through category interests' do
      expect(user1.categories.find { |c| c == category1 }).not_to be_nil
    end

    it 'does not create a link from non-commercial users through category interests' do
      expect(reporter1.categories.find { |c| c == category1 }).to be_nil
    end
  end

  describe '#commercial' do
    it 'Returns true if the user is of role user or advertiser' do
      user = create(:user, role: described_class.roles[:user])
      expect(user.commercial).to be true
    end

    it 'Returns false if the user is of role admin or reporter' do
      user = create(:user, role: described_class.roles[:reporter])
      expect(user.commercial).to be false
    end
  end

  it 'shows future outings' do
    expect(future_outing1.date).to eq(Time.zone.today + 1.day)
  end

  describe '#future_outings' do
    it 'returns all outings in the future' do
      expect(creator_user.future_outings).to include(future_outing1)
      expect(creator_user.future_outings).to include(future_outing2)
    end

    it 'doesnt return outings in the past' do
      expect(creator_user.future_outings).not_to include(past_outing1)
      expect(creator_user.future_outings).not_to include(past_outing2)
    end
  end
end
