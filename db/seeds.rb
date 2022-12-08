# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user_admin1 = FactoryBot.create(:user, email: "admin1@planetgo.com", password: "password", role: 2)
user_admin2 = FactoryBot.create(:user, email: "admin2@planetgo.com", password: "password", role: 2)

user_user1 = FactoryBot.create(:user, email: "user1@gmail.com", password: "password", role: 1)
user_user2 = FactoryBot.create(:user, email: "user2@gmail.com", password: "password", role: 1)

review_positive1 = FactoryBot.create(:review,
                                     body: "This is a great website! I'd recommend it to anyone",
                                     user: user_user1.id
                                    )
