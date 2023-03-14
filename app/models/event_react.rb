class EventReact < ApplicationRecord
  enum status: {
    like: 0,
    dislike: 1,
    theatre: 2,   #theatre
    sport: 3,     #sport
    ️creativity: 4,#creativity
    games: 5,     #games
    car: 6,       #car
    train: 7,     #train
    photogenic: 8,#photogenic
    nature: 9,    #nature
    food: 10,     #food
    pub: 11,      #beer
    bar: 12,      #drinks
    movies: 13    #film

  }

  # 🎭: 2, #theatre
  #   ⚽: 3, #sport
  #   ️🎨: 4, #creativity
  #   🎸: 5, #music
  #   🎮: 6, #games
  #   🚗: 7, #car
  #   🚂: 8, #train
  #   📸: 9, #photogenic
  #   🌳: 10,#nature
  #   🍕: 11,#food
  #   🍺: 12,#beer
  #   🍸: 13,#drinks
  #   🎬: 14 #film

  belongs_to :user
  belongs_to :event

  validates :status, presence: true

  def tags
    EventReact.statuses[2..]
  end
end
