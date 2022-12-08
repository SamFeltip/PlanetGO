# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


metrics = Metric.create([{time_enter: "2022-11-25 12:24:16", time_exit: "2022-11-25 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "GB", is_logged_in: false, number_interactions: 4, pricing_selected: 1},
  {time_enter: "2022-11-25 12:22:16", time_exit: "2022-11-25 12:25:16", route: "/reviews", latitude: 53.376347, longitude: -1.488364, country_code: "GB", is_logged_in: false, number_interactions: 4, pricing_selected: 1},
  {time_enter: "2022-11-25 12:21:16", time_exit: "2022-11-25 12:25:16", route: "/reviews", latitude: 39.341952, longitude: -93.907174, country_code: "US", is_logged_in: false, number_interactions: 6, pricing_selected: 1},
  {time_enter: "2022-11-26 12:24:16", time_exit: "2022-11-26 12:25:16", route: "/reviews", latitude: 53.376347, longitude: -1.488364, country_code: "GB", is_logged_in: false, number_interactions: 2, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/reviews", latitude: 53.376347, longitude: -1.488364, country_code: "GB", is_logged_in: false, number_interactions: 8, pricing_selected: 1},
  {time_enter: "2022-11-25 12:24:16", time_exit: "2022-11-25 12:25:16", route: "/", latitude: 39.341952, longitude: -93.907174, country_code: "US", is_logged_in: false, number_interactions: 1, pricing_selected: 1},
  {time_enter: "2022-11-26 12:24:16", time_exit: "2022-11-26 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "CN", is_logged_in: false, number_interactions: 0, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "RU", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "GB", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "AF", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "AD", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "AW", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "GB", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "EG", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "IE", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "ML", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "YT", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "IN", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "IN", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "IN", is_logged_in: false, number_interactions: 5, pricing_selected: 1},
  {time_enter: "2022-11-27 12:24:16", time_exit: "2022-11-27 12:25:16", route: "/", latitude: 53.376347, longitude: -1.488364, country_code: "IN", is_logged_in: false, number_interactions: 5, pricing_selected: 1}])

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
