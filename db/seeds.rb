# frozen_string_literal: true

default_password = 'SneakyPassword100'



user_admin1 = User.where(email: 'admin1@planetgo.com')
                  .first_or_create(
                    role: User.roles[:admin],
                    password: default_password,
                    full_name: 'Arielle Norman'
                  )

user_admin2 = User.where(email: 'admin2@planetgo.com')
                  .first_or_create(
                    role: User.roles[:admin],
                    password: default_password,
                    full_name: 'Miguel Whitaker'
                  )

user_advertiser1 = User.where(email: 'advertiser1@company.com')
                       .first_or_create(
                         role: User.roles[:advertiser],
                         password: default_password,
                         full_name: 'Billy Adams'
                       )

user_advertiser2 = User.where(email: 'advertiser2@company.com')
                       .first_or_create(
                         role: User.roles[:advertiser],
                         password: default_password,
                         full_name: 'Mango Cavern'
                       )


user_rep1 = User.where(email: 'rep1@planetgo.com')
                .first_or_create(
                  role: User.roles[:reporter],
                  password: default_password,
                  full_name: 'Houston Davila'
                )

user_rep2 = User.where(email: 'rep2@planetgo.com')
                .first_or_create(
                  role: User.roles[:reporter],
                  password: default_password,
                  full_name: 'Lea Park'
                )

user_user1 = User.where(email: 'user1@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Anna Hudson'
                 )

user_user2 = User.where(email: 'user2@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Jamie Lindsey'
                 )

user_user3 = User.where(email: 'user3@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Mason Mccoy'
                 )

user_user4 = User.where(email: 'user4@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Angelina Bevon'
                 )

user_emails = ['user5@gmail.com','user6@gmail.com','user7@gmail.com','user8@gmail.com','user9@gmail.com','user10@gmail.com','user11@gmail.com','user12@gmail.com']
user_list = []
user_emails.each do |email|
  user_list << (
    User.where(email: email)
      .first_or_create(
        role: User.roles[:user],
        password: default_password,
        full_name: Faker::Name.name
      )
  )
end

def make_friend(user_sending, user_receiving)
  user_sending.send_follow_request_to(user_receiving)
  user_receiving.accept_follow_request_of(user_sending)

  user_receiving.send_follow_request_to(user_sending)
  user_sending.accept_follow_request_of(user_receiving)
end

make_friend(user_user1, user_user2)
make_friend(user_user1, user_user3)
make_friend(user_user1, user_user4)
make_friend(user_user2, user_user3)
make_friend(user_user2, user_user4)
make_friend(user_user3, user_user4)
make_friend(user_user1, user_rep1)
make_friend(user_user1, user_rep2)
make_friend(user_user1, user_advertiser1)
make_friend(user_user1, user_advertiser2)
make_friend(user_user2, user_rep1)
make_friend(user_user2, user_rep2)

category_bar = Category.first_or_create(
  name: 'Bar'
)

category_restaurant = Category.where(
  name: 'Restaurant'
).first_or_create

category_theatre = Category.where(
  name: 'Theatre'
).first_or_create

category_music = Category.where(
  name: 'Music'
).first_or_create

category_sports = Category.where(
  name: 'Sports'
).first_or_create

event_list = []

event_1 = Event.where(
  user_id: user_advertiser1.id,
  name: "Billy's Pizza cooking class",
  address_line1: '44 Highfield Road',
  town: 'Southampton',
  postcode: 'SO17 1PJ',
  latitude: 50.93179575,
  longitude: -1.40230945,
  description: 'Edible Pizza at suspiciously low prices',
  category_id: category_restaurant.id,
  time_of_event: 7.days.from_now
).first_or_create

event_2 = Event.where(
  user_id: user_advertiser1.id,
  name: "Billy's Pasta tasting",
  description: "I'll be honest, even I wouldn't eat the food we serve",
  address_line1: '9273 London Road',
  town: 'Romford',
  postcode: 'RM7 9QD',
  latitude: 51.5760019,
  longitude: 0.1768541,
  category_id: category_restaurant.id,
  time_of_event: 7.days.from_now
).first_or_create

event_3 = Event.where(
  user_id: user_advertiser1.id,
  name: 'Pub Quiz',
  address_line1: '442 Queen Street',
  town: 'Manchester',
  postcode: 'M2 5HS',
  latitude: 53.5375048,
  longitude: -2.0653505,
  description: "Our pub quiz is so hard you'll probably want a drink after getting all the questions wrong. 'Beer' £8 per half pint",
  category_id: category_bar.id,
  time_of_event: 7.days.from_now,
  approved: true
).first_or_create

event_4 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Half Price Wednesdays',
  address_line1: '75 Park Lane',
  town: 'Walsall',
  postcode: 'B42 1TX',
  latitude: 52.5704048,
  longitude: -2.0184091,
  description: 'Head down to Mango Cavern for half price on cocktails this wednesday!',
  category_id: category_bar.id,
  approved: true
).first_or_create

event_5 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Quiz night',
  address_line1: '9698 Chester Road',
  town: 'Hull',
  postcode: 'HU5 5QE',
  latitude: 53.7599899,
  longitude: -0.4138144,
  description: "We have a super hard quiz, you'll never win the prize!",
  category_id: category_sports.id,
  time_of_event: 3.days.from_now,
  approved: true
).first_or_create

event_6 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Andrews Bar',
  address_line1: '90 Grove Road',
  town: 'Brighton',
  postcode: 'BN2 9NY',
  latitude: 53.4304007,
  longitude: -3.0568491,
  description: "Come to this bar, it's great!",
  category_id: category_music.id,
  approved: true
).first_or_create

event_7 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Bobs Comedy Club',
  address_line1: '1 Albert Road',
  town: 'Cardiff',
  postcode: 'BN2 9NY',
  latitude: 53.4304007,
  longitude: -3.0568491,
  description: 'Bob is a funny guy, come and see him!',
  category_id: category_theatre.id,
  approved: true
).first_or_create

event_8 = Event.where(
  user_id: user_advertiser1.id,
  name: 'Tzatziki Tuesdays',
  address_line1: '5 Albert Road',
  town: 'Cardiff',
  postcode: 'CF10 3DN',
  latitude: 51.4814007,
  longitude: -3.1768491,
  description: 'Come and try our new Tzatziki Tuesdays!',
  category_id: category_restaurant.id,
  approved: true
).first_or_create

event_9 = Event.where(
  user_id: user_advertiser2.id,
  name: "Music Festival",
  address_line1: "123 Main Street",
  town: "Springfield",
  postcode: "SW1A 1AA",
  latitude: 40.712776,
  longitude: -74.005974,
  description: "A day-long festival featuring live music from local bands.",
  category_id: category_music.id,
  approved: true
).first_or_create

event_10 = Event.where(
  user_id: user_advertiser2.id,
  name: "Art Show",
  address_line1: "456 Elm Street",
  town: "Shelbyville",
  postcode: "B1 1BB",
  latitude: 41.878113,
  longitude: -87.629799,
  description: "An exhibition of paintings and sculptures by local artists.",
  category_id: category_music.id,
  approved: true
).first_or_create

event_11 = Event.where(
  user_id: user_advertiser2.id,
  name: "Food Festival",
  address_line1: "789 Oak Street",
  town: "Capital City",
  postcode: "M1 1AE",
  latitude: 34.052235,
  longitude: -118.243683,
  description: "A celebration of local cuisine with food stalls and cooking demonstrations.",
  category_id: category_restaurant.id,
  approved: true
).first_or_create

event_12 = Event.where(
  user_id: user_advertiser2.id,
  name: "Book Fair",
  address_line1: "321 Maple Street",
  town: "Ogdenville",
  postcode: "CF10 1BH",
  latitude: 42.360081,
  longitude: -71.058884,
  description: "A gathering of booksellers and publishers with book signings and readings.",
  category_id: category_theatre.id,
  approved:true
).first_or_create

event_13 = Event.where(
  user_id:user_advertiser2.id,
  name:"Film Festival",
  address_line1:"159 Hollywood Boulevard",
  town:"Los Angeles",
  postcode:"BT1 5GS",
  latitude:"34.0928092",
  longitude:"-118.3286614",
  description:"A week-long festival showcasing independent films from around the world.",
  category_id:category_music.id,
  approved:true
).first_or_create

event_14 = Event.where(
  user_id:user_advertiser2.id,
  name:"Comedy Night",
  address_line1:"753 Broadway Street",
  town:"New York City",
  postcode:"LS1 1UR",
  latitude:"40.7322535",
  longitude:"-73.9874105",
  description:"A night of stand-up comedy featuring local comedians.",
  category_id:category_bar.id,
  approved:true
).first_or_create

event_15 = Event.where(
  user_id:user_advertiser2.id,
  name:"Farmers Market",
  address_line1:"246 Rural Road",
  town:"Smallville",
  postcode:"G1 1XU",
  latitude:"38.2544472",
  longitude:"-85.7591230",
  description:"A weekly market featuring fresh produce and handmade goods from local farmers and artisans.",
  category_id:category_restaurant.id,
  approved:true
).first_or_create

event_16 = Event.where(
  user_id:user_advertiser2.id,
  name:"Craft Fair",
  address_line1:"369 Main Street",
  town:"Riverdale",
  postcode:"NE1 6EE",
  latitude:"41.1536674",
  longitude:"-73.2829269",
  description:"A fair showcasing handmade crafts and goods from local artisans.",
  category_id:category_sports.id,
  approved:true
).first_or_create

event_17 = Event.where(
  user_id:user_advertiser2.id,
  name:"Wine Tasting",
  address_line1:"654 Vineyard Lane",
  town:"Napa",
  postcode:"L1 8JQ",
  latitude:"38.5024689",
  longitude:"-122.2653887",
  description:"An evening of wine tasting featuring local wineries.",
  category_id:category_bar.id,
  approved:true
).first_or_create

random_event_and_user_pairs = [
  [1, 1],
  [5, 10],
  [17, 2],
  [2, 3],
  [7, 15],
  [3, 12],
  [16, 6],
  [8, 18],
  [14, 4],
  [11, 9],
  [13, 7],
  [4, 16],
  [6, 14],
  [15, 5],
  [12, 8],
  [9, 17],
  [10, 11],
  [18,13]
]

random_event_and_user_pairs.each do |pair|

    user_id = pair[0]
    event_id = pair[1]

    EventReact.where(
      user_id: user_id,
      event_id: event_id
    ).first_or_create

end


outing1 = Outing.where(
  name: 'Pizza Time',
  date: 1.week.from_now,
  creator_id: user_user1.id
).first_or_create

outing2 = Outing.where(
  name: 'Hoover Convention',
  date: 2.weeks.from_now,
  creator_id: user_user1.id
).first_or_create

outing3 = Outing.where(
  name: 'Bar Crawl',
  date: 1.week.ago,
  creator_id: user_user2.id
).first_or_create

outing4 = Outing.where(
  name: 'Movie Night',
  date: 3.weeks.from_now,
  creator_id: user_user2.id
).first_or_create

outing5 = Outing.where(
  name: 'Pub Quiz crawl',
  date: 2.weeks.from_now,
  creator_id: user_user3.id
).first_or_create

# create participants for every creator of every outing
[outing1, outing2, outing3, outing4, outing5].each do |outing|
  Participant.where(
    user_id: outing.creator_id,
    outing_id: outing.id,
    status: "creator"
  ).first_or_create
end

time_periods = [
  1.week.from_now,
  3.days.from_now,
  1.week.from_now + 2.days,
  5.days.from_now,
  1.month.from_now,
  2.weeks.from_now + 3.hours,
  4.days.from_now + 6.hours,
  6.days.from_now + 12.hours,
  2.months.from_now + 1.week + 2.days,
  3.weeks.from_now + 4.days + 8.hours,
  4.weeks.from_now + 5.days + 10.hours,
  5.weeks.from_now + 6.days + 12.hours,
  6.weeks.from_now + 7.days + 14.hours,
  7.weeks.from_now + 8.days + 16.hours,
  2.months.from_now + 3.weeks.from_now + 17.hours,
 (3.months + 1.day).from_now+18.hours,
 (4.months + 2.weeks).from_now+19.hours,
]

outing_list = [outing3,  outing1,  outing4,  outing2,  outing5,  outing2,  outing1,  outing3,  outing5,  outing4,  outing2,  outing1,  outing4,  outing3,  outing5,  outing1,  outing2]
event_list = [event_1, event_2, event_3, event_4, event_5, event_6, event_7, event_8, event_9, event_10, event_11, event_12, event_13, event_14, event_15, event_16, event_17]

print 'making proposed events'

# zip the three lists together
outing_list.zip(event_list, time_periods).each do |outing, event, time_period|
  print '.'
  ProposedEvent.where(
    outing_id: outing.id,
    event_id: event.id,
    proposed_datetime: time_period
  ).first_or_create

end


# create participants for every user of every outing

user_ids = [6, 14, 5, 12, 3, 17, 8, 1, 11, 16, 2, 7, 13, 18, 9, 4, 15]

# zip user_ids, outings together
participant_zips = user_ids.zip(outing_list)

puts user_ids.length
puts participant_zips

print 'making participants'
participant_zips.each do |user_id, outing|
  print '.'
  user = User.find(user_id)

  status = "confirmed"

  # random but reproducible pending requests
  if user_id + outing.id % 2 == 0
    status = "pending"
  end

  if outing.creator_id == user_id
    status = "creator"
  end

  Participant.where(
    user_id: user,
    outing_id: outing.id,
    status: status
  ).first_or_create

end

puts ''
print 'printing metrics'

metric_1 = Metric.where(
  time_enter: '2022-11-25 12:24:16', time_exit: '2022-11-25 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 4, pricing_selected: 1
).first_or_create

metric_6 = Metric.where(
  time_enter: '2022-11-25 12:24:16', time_exit: '2022-11-25 12:25:16', route: '/', latitude: 39.341952,
  longitude: -93.907174, country_code: 'US', is_logged_in: false, number_interactions: 1, pricing_selected: 1
).first_or_create

metric_7 = Metric.where(
  time_enter: '2022-11-26 12:24:16', time_exit: '2022-11-26 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'CN', is_logged_in: false, number_interactions: 0, pricing_selected: 1
).first_or_create

metric_8 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'RU', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_9 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_10 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AF', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_11 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AD', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_12 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AW', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_13 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_14 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'EG', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_15 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IE', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_16 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'ML', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_17 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'YT', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_18 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_19 = Metric.where(
  time_enter: '2022-11-27 12:24:17', time_exit: '2022-11-27 12:25:17', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_20 = Metric.where(
  time_enter: '2022-11-27 12:24:18', time_exit: '2022-11-27 12:25:18', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create

metric_21 = Metric.where(
  time_enter: '2022-11-27 12:24:19', time_exit: '2022-11-27 12:25:19', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5, pricing_selected: 1
).first_or_create