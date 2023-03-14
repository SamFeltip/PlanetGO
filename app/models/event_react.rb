class EventReact < ApplicationRecord
  enum status: { like: 0 }

  belongs_to :user
  belongs_to :event

  validates :status, presence: true
end
