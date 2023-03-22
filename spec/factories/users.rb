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
FactoryBot.define do
  sequence :email do |n|
    "test#{n}@planetgo.com"
  end

  sequence :full_name do
    # ('a'..'z').to_a.shuffle.join
    #
    vowels = (%w[a e i o u] * 8).shuffle
    letters = (('a'..'z').to_a - vowels - ['q']).shuffle

    first_name = letters.zip(vowels).flatten[0..5].join

    second_name = letters.zip(vowels).flatten[6..8].join + letters.zip(vowels).flatten[10..12].join

    "#{first_name} #{second_name}"
  end

  factory :user do
    email
    full_name
    password { 'SneakyPassword100' }
    role { User.roles[:user] }
    last_sign_in_at { Time.new(2023, 1, 12).utc }
  end
end
