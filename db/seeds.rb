# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# user_admin1 = FactoryBot.create(:user, email: 'admin1@planetgo.com', role: 2)
default_password = 'SneakyPassword100'
puts 'Seeding Database'

print '[+] Adding raw users.'

user_admin1 = User.where(email: 'admin1@planetgo.com')
                  .first_or_create(
                    role: 2,
                    password: default_password
                  )

print '.'
# user_admin2 = FactoryBot.create(:user, email: 'admin2@planetgo.com', role: 2)
user_admin2 = User.where(email: 'admin2@planetgo.com')
                  .first_or_create(
                    role: 2,
                    password: default_password
                  )

print '.'
user_user1 = User.where(email: 'user1@gmail.com')
                 .first_or_create(
                   role: 1,
                   password: default_password
                 )

puts '.'
user_user2 = User.where(email: 'user2@gmail.com')
                 .first_or_create(
                   role: 2,
                   password: default_password
                 )

print '[+] Adding new reviews.'
review_1 = Review.where(body: "This is a great website! I'd recommend it to anyone")
                 .first_or_create(
                   user: user_admin1,
                   is_on_landing_page: true
                 )

print '.'
review_1 = Review.where(body: "This is an AMAZING website! I'd recommend it, even if they were on their deathbed. Everyone MUST use this program, and share it with all their friends!")
                 .first_or_create(
                   user: user_user1,
                   is_on_landing_page: true
                 )

puts '.'
review_3 = Review.where(body: 'I HATE this website. It offends me deeply this product even exists. I want an apology note ASAP')
                 .first_or_create(
                   user: user_user2)

print '[+] Adding new FAQs.'

faq_1 = Faq.where(question: 'how do I make an account?')
           .first_or_create(
             answer: 'it\'s easy, you go to the sign up page!'
           )

puts '.'

faq_2 = Faq.where(question: 'where can I sign up!?')
           .first_or_create(
             answer: 'go to /users/sign_up and fill in your details!'
           )

puts 'Seed complete!'
