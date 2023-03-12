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
  it 'Returns the name when converted to a string' do
    user = create(:user, full_name: 'John Smith', email: 'testemail@email.com')
    expect(user.to_s).to eq 'John Smith'
  end

  it 'Returns the prefix of an email' do
    user = create(:user, full_name: 'John Smith', email: 'testemail@email.com')
    expect(user.email_prefix).to eq 'testemail'
  end

  describe '#commercial' do
    it 'Returns true if the user is of role user or advertiser' do
      user = FactoryBot.create(:user, role: 'user')
      expect(user.commercial).to eq true
    end

    it 'Returns false if the user is of role admin or reporter' do
      user = FactoryBot.create(:user, role: 'reporter')
      expect(user.commercial).to eq false
    end
  end

  context "declaring availability" do
    describe "when submit a time I am available" do
      it "is recorded" do

      end

      it "is visible on my personal user page" do

      end

    end
  end



end
