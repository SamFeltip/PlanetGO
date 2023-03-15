class EventReact < ApplicationRecord

  belongs_to :user
  belongs_to :event

  enum status: {
    like: 0,
    dislike: 1
  }

  validates :status, presence: true


end
