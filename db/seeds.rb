# frozen_string_literal: true

default_password = 'SneakyPassword100'
Rails.logger.debug 'Seeding Database'

Rails.logger.debug '[+] Adding raw users.'

user_admin1 = User.where(email: 'admin1@planetgo.com')
                  .first_or_create(
                    role: 2,
                    password: default_password,
                    full_name: 'Arielle Norman'
                  )

user_advertiser1 = User.where(email: 'advertiser1@company.com')
                       .first_or_create(
                         role: User.roles[:advertiser],
                         password: default_password,
                         full_name: 'Billy Adams'
                       )

Rails.logger.debug '.'

user_admin2 = User.where(email: 'admin2@planetgo.com')
                  .first_or_create(
                    role: 2,
                    password: default_password,
                    full_name: 'Miguel Whitaker'
                  )

Rails.logger.debug '.'

user_rep1 = User.where(email: 'rep1@planetgo.com')
                .first_or_create(
                  role: 1,
                  password: default_password,
                  full_name: 'Houston Davila'
                )

Rails.logger.debug '.'

user_rep2 = User.where(email: 'rep2@planetgo.com')
                .first_or_create(
                  role: 1,
                  password: default_password,
                  full_name: 'Lea Park'
                )

Rails.logger.debug '.'

user_user1 = User.where(email: 'user1@gmail.com')
                 .first_or_create(
                   role: 0,
                   password: default_password,
                   full_name: 'Anna Hudson'
                 )

Rails.logger.debug '.'
user_user2 = User.where(email: 'user2@gmail.com')
                 .first_or_create(
                   role: 0,
                   password: default_password,
                   full_name: 'Jamie Lindsey'
                 )
Rails.logger.debug '[+] Adding new event categories.'
category_1 = Category.where(
  name: 'Bar'
).first_or_create

Rails.logger.debug '.'
category_2 = Category.where(
  name: 'Restaurant'
).first_or_create

Rails.logger.debug '.'
category_3 = Category.where(
  name: 'Theatre'
).first_or_create

Rails.logger.debug '.'
category_4 = Category.where(
  name: 'Music'
).first_or_create

Rails.logger.debug '.'
category_5 = Category.where(
  name: 'Sports'
).first_or_create

Rails.logger.debug '[+] Adding new events.'
event_1 = Event.where(
  user_id: user_advertiser1.id,
  name: "Billy's Pizza",
  description: 'Edible Pizza at suspiciously low prices',
  category_id: category_2.id,
  time_of_event: Time.now + 7.days
).first_or_create

Rails.logger.debug '[+] Adding new metrics.'

metric_1 = Metric.where(
  time_enter: '2022-11-25 12:24:16', time_exit: '2022-11-25 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 4, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_6 = Metric.where(
  time_enter: '2022-11-25 12:24:16', time_exit: '2022-11-25 12:25:16', route: '/', latitude: 39.341952,
  longitude: -93.907174, country_code: 'US', is_logged_in: false, number_interactions: 1, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_7 = Metric.where(
  time_enter: '2022-11-26 12:24:16', time_exit: '2022-11-26 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'CN', is_logged_in: false, number_interactions: 0, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_8 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'RU', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_9 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_10 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AF', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_11 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AD', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_12 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AW', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_13 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_14 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'EG', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_15 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IE', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_16 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'ML', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_17 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'YT', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_18 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_19 = Metric.where(
  time_enter: '2022-11-27 12:24:17', time_exit: '2022-11-27 12:25:17', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_20 = Metric.where(
  time_enter: '2022-11-27 12:24:18', time_exit: '2022-11-27 12:25:18', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug '.'

metric_21 = Metric.where(
  time_enter: '2022-11-27 12:24:19', time_exit: '2022-11-27 12:25:19', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

Rails.logger.debug 'Seed complete!'
