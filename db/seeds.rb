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
review_2 = Review.where(body: "This is an AMAZING website! I'd recommend it, even if they were on their deathbed. Everyone MUST use this program, and share it with all their friends!")
                 .first_or_create(
                   user: user_user1,
                   is_on_landing_page: true
                 )

puts '.'
review_3 = Review.where(body: 'I HATE this website. It offends me deeply this product even exists. I want an apology note ASAP')
                 .first_or_create(
                   user: user_user2
                 )

print '[+] Adding new FAQs.'

faq_1 = Faq.where(question: 'How do I make an account?')
           .first_or_create(
             answer: 'it\'s easy, you go to the sign up page!',
             answered: true,
             displayed: true
           )

puts '.'

faq_2 = Faq.where(question: 'Where can I sign up!?')
           .first_or_create(
             answer: 'go to /users/sign_up and fill in your details!',
             answered: true,
             displayed: true
           )

puts '.'

faq_3 = Faq.where(question: 'How much does it cost?')
           .first_or_create(
             answer: 'Go check out our pricing options on the pricing page.',
             answered: false,
             displayed: false
           )

print '[+] Adding new metrics.'

metric_1 = Metric.where(
  time_enter: '2022-11-25 12:24:16', time_exit: '2022-11-25 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 4, pricing_selected: 1
).first_or_create

print '.'

metric_2 = Metric.where(time_enter: '2022-11-25 12:22:16', time_exit: '2022-11-25 12:25:16', route: '/reviews', latitude: 53.376347,
                        longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 4, pricing_selected: 1).first_or_create

print '.'

metric_3 = Metric.where(
  time_enter: '2022-11-25 12:21:16', time_exit: '2022-11-25 12:25:16', route: '/reviews', latitude: 39.341952,
  longitude: -93.907174, country_code: 'US', is_logged_in: false, number_interactions: 6, pricing_selected: 1
).first_or_create

print '.'

metric_4 = Metric.where(
  time_enter: '2022-11-26 12:24:16', time_exit: '2022-11-26 12:25:16', route: '/reviews', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 2, pricing_selected: 1
).first_or_create

print '.'

metric_5 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/reviews', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 8, pricing_selected: 1
).first_or_create

print '.'

metric_6 = Metric.where(
  time_enter: '2022-11-25 12:24:16', time_exit: '2022-11-25 12:25:16', route: '/', latitude: 39.341952,
  longitude: -93.907174, country_code: 'US', is_logged_in: false, number_interactions: 1, pricing_selected: 1
).first_or_create

print '.'

metric_7 = Metric.where(
  time_enter: '2022-11-26 12:24:16', time_exit: '2022-11-26 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'CN', is_logged_in: false, number_interactions: 0, pricing_selected: 1
).first_or_create

print '.'

metric_8 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'RU', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_9 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_10 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AF', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_11 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AD', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_12 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AW', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_13 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_14 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'EG', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_15 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IE', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_16 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'ML', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_17 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'YT', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_18 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_19 = Metric.where(
  time_enter: '2022-11-27 12:24:17', time_exit: '2022-11-27 12:25:17', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

print '.'

metric_20 = Metric.where(
  time_enter: '2022-11-27 12:24:18', time_exit: '2022-11-27 12:25:18', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

puts '.'

metric_21 = Metric.where(
  time_enter: '2022-11-27 12:24:19', time_exit: '2022-11-27 12:25:19', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

puts 'Seed complete!'
