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
class User < ApplicationRecord
  has_many :reviews, dependent: :delete_all
  has_many :participants
  has_many :outings, class_name: "Outing", :through => :participants

  acts_as_voter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :secure_validatable,
         :pwned_password, :lockable, :trackable

  enum role: {
    user: 0,
    reporter: 1,
    admin: 2
  }

  # this function is trying to get all outings this user has created using a joiner with the participants table
  def my_outings

    outings = Outing.all
    future_outings = Outing.none

    outings.each do |outing|
      if outing.time_status == "future"
          future_outings = future_outings.or(
            Outing.where(
              id: Outing.joins(:participants).where(id: outing.id, participants: { status: Participant.statuses[:creator], user_id: self.id })
            )
          )

      end

    end

  end

  def to_s
    if full_name?
      full_name
    else
      email_prefix
    end
  end

  def email_prefix
    email.split('@')[0]
  end
end
