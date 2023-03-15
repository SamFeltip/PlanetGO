# frozen_string_literal: true

default_password = 'SneakyPassword100'
puts 'Seeding Database'

print '[+] Adding raw users.'

user_admin1 = User.where(email: 'admin1@planetgo.com')
                  .first_or_create(
                    role: User.roles[:admin],
                    password: default_password,
                    full_name: 'Arielle Norman'
                  )

print '.'
user_advertiser1 = User.where(email: 'advertiser1@company.com')
                       .first_or_create(
                         role: User.roles[:advertiser],
                         password: default_password,
                         full_name: 'Billy Adams'
                       )

print '.'

user_admin2 = User.where(email: 'admin2@planetgo.com')
                  .first_or_create(
                    role: User.roles[:admin],
                    password: default_password,
                    full_name: 'Miguel Whitaker'
                  )

print '.'

user_rep1 = User.where(email: 'rep1@planetgo.com')
                .first_or_create(
                  role: User.roles[:reporter],
                  password: default_password,
                  full_name: 'Houston Davila'
                )

print '.'

user_rep2 = User.where(email: 'rep2@planetgo.com')
                .first_or_create(
                  role: User.roles[:reporter],
                  password: default_password,
                  full_name: 'Lea Park'
                )

print '.'

user_user1 = User.where(email: 'user1@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Anna Hudson'
                 )

puts '.'
user_user2 = User.where(email: 'user2@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Jamie Lindsey'
                 )



Rails.logger.debug '[+] Adding new events.'
event_1 = Event.where(
  user_id: user_advertiser1.id,
  name: "Billy's Pizza",
  description: 'Edible Pizza at suspiciously low prices',
  category: Event.categories[:restaurant],
  time_of_event: Time.now + 7.days
).first_or_create



print '[+] Adding new outings'
print '.'
outing1 = Outing.where(
  name: "Pizza Time",
  date: Time.now + 1.week,
  creator_id: user_user1.id
).first_or_create


puts '.'
outing2 = Outing.where(
  name: "Hoover Convention",
  date: Time.now + 2.week,
  creator_id: user_user1.id
).first_or_create

puts '.'
outing3 = Outing.where(
  name: "Bar Crawl",
  date: Time.now - 1.week,
  creator_id: user_user2.id
).first_or_create


print '[+] Adding new participants'

print "."
participant_outing1_1 = Participant.where(
  user_id: user_user1.id,
  outing_id: outing1,
  status: Participant.statuses[:creator]
).first_or_create


print "."
participant_outing1_2 = Participant.where(
  user_id: user_user2.id,
  outing_id: outing1,
  status: Participant.statuses[:pending]
).first_or_create

print "."
participant_outing3_1 = Participant.where(
  user_id: user_user2.id,
  outing_id: outing3,
  status: Participant.statuses[:creator]
).first_or_create


print "."
participant_outing3_2 = Participant.where(
  user_id: user_user1.id,
  outing_id: outing3,
  status: Participant.statuses[:pending]
).first_or_create

puts "."
participant_outing2_1 = Participant.where(
  user_id: user_user1.id,
  outing_id: outing2,
  status: Participant.statuses[:creator]
).first_or_create


print '[+] Adding new metrics.'
Rails.logger.debug '[+] Adding new events.'
event_1 = Event.where(
  user_id: user_advertiser1.id,
  name: "Billy's Pizza",
  description: 'Edible Pizza at suspiciously low prices',
  category: Event.categories[:restaurant],
  time_of_event: Time.now + 7.days
).first_or_create

Rails.logger.debug '[+] Adding new metrics.'

metric_1 = Metric.where(
  time_enter: '2022-11-25 12:24:16', time_exit: '2022-11-25 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 4, pricing_selected: 1
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
