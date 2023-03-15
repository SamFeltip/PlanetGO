class EventReact < ApplicationRecord

  belongs_to :user
  belongs_to :event

  enum status: {
    like: 0,
    dislike: 1
  }

  validates :status, presence: true

  #   🎭 : 2,  #theatre
  #   ⚽ : 3,  #sport
  # ️ 🎨: 4,  #creativity
  #   🎸 : 5,  #music
  #   🎮 : 6,  #games
  #   🚗 : 7,  #car
  #   🚂 : 8,  #train
  #   📸 : 9,  #photogenic
  #   🌳 : 10, #nature
  #   🍕 : 11, #food
  #   🍺 : 12, #beer
  #   🍸 : 13, #drinks
  #   🎬 : 14  #film

end
