# frozen_string_literal: true

default_password = 'SneakyPassword100'

user_admin1 = User.where(email: 'admin1@planetgo.com')
                  .first_or_create(
                    role: User.roles[:admin],
                    password: default_password,
                    full_name: 'Arielle Norman'
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

user_admin2 = User.where(email: 'admin2@planetgo.com')
                  .first_or_create(
                    role: User.roles[:admin],
                    password: default_password,
                    full_name: 'Miguel Whitaker'
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
                   full_name: 'Anna Hudson',
                   postcode: 'S3 7RS'
                 )

user_user2 = User.where(email: 'user2@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Jamie Lindsey',
                   postcode: 'S3 8RA'
                 )

user_user3 = User.where(email: 'user3@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Mason Mccoy',
                   postcode: 'S3 7PN'
                 )

user_user4 = User.where(email: 'user4@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Angelina Bevon',
                   postcode: 'WC2B 4PA'
                 )

user_user5 = User.where(email: 'user5@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Matthew Rodriguez',
                   postcode: 'M14 6EU'
                 )

user_user6 = User.where(email: 'user6@gmail.com')
                 .first_or_create(
                   role: User.roles[:user],
                   password: default_password,
                   full_name: 'Emily Johnson',
                   postcode: 'SE18 2HB'
                 )

user_user1.send_follow_request_to(user_user2)
user_user2.accept_follow_request_of(user_user1)

user_user2.send_follow_request_to(user_user1)
user_user1.accept_follow_request_of(user_user2)

user_user1.send_follow_request_to(user_user3)
user_user3.accept_follow_request_of(user_user1)

user_user3.send_follow_request_to(user_user1)
user_user1.accept_follow_request_of(user_user3)

category_1 = Category.first_or_create(
  name: 'Bar'
)

category_2 = Category.where(
  name: 'Restaurant'
).first_or_create

category_3 = Category.where(
  name: 'Theatre'
).first_or_create

category_4 = Category.where(
  name: 'Music'
).first_or_create

category_5 = Category.where(
  name: 'Sports'
).first_or_create

event_1 = Event.where(
  user_id: user_advertiser1.id,
  name: "Billy's Pizza cooking class",
  address_line1: '44 Highfield Road',
  town: 'Southampton',
  postcode: 'SO17 1PJ',
  latitude: 50.93179575,
  longitude: -1.40230945,
  description: 'Edible Pizza at suspiciously low prices',
  category_id: category_2.id,
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
  category_id: category_2.id,
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
  category_id: category_1.id,
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
  category_id: category_1.id,
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
  category_id: category_5.id,
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
  category_id: category_4.id,
  approved: true
).first_or_create

event_7 = Event.where(
  user_id: user_advertiser1.id,
  name: "The Golden Lion Pub Quiz",
  address_line1: '36 York Street',
  town: 'Norwich',
  postcode: 'NR2 2DU',
  latitude: 52.6266995,
  longitude: 1.2927062,
  description: "Come along to The Golden Lion pub and join in our weekly quiz. Test your knowledge with our fun and challenging questions, while enjoying a pint of our locally brewed beer. Our quiz is free to enter, and the winning team receives a £50 bar tab. Plus, we have plenty of other prizes up for grabs throughout the night. So gather your friends and come along for a great evening of fun and games!",
  category_id: category_1.id,
  time_of_event: 10.days.from_now,
  approved: true
  ).first_or_create

event_8 = Event.where(
  user_id: user_advertiser2.id,
  name: "Taste of India pop-up restaurant",
  address_line1: '71 High Street',
  town: 'Birmingham',
  postcode: 'B17 9NS',
  latitude: 52.4581445,
  longitude: -1.9795945,
  description: "Come and experience the flavours of India at our pop-up restaurant. Our talented chefs have created a delicious menu featuring a range of traditional dishes and modern twists. Start with our spicy samosas or tangy chaat, before moving on to our rich curries and biryanis. And don't forget to leave room for our decadent desserts! Our pop-up is only open for a limited time, so book your table now to avoid disappointment.",
  category_id: category_2.id,
  time_of_event: 14.days.from_now,
  approved: true
  ).first_or_create
  
event_9 = Event.where(
  user_id: user_advertiser1.id,
  name: "The Phantom of the Opera",
  address_line1: 'Shaftesbury Avenue',
  town: 'London',
  postcode: 'W1D 7EZ',
  latitude: 51.5132894,
  longitude: -0.1319312,
  description: "Experience the magic of The Phantom of the Opera at Her Majesty's Theatre. This timeless musical tells the story of a mysterious figure who haunts the Paris Opera House, and the young soprano who becomes his obsession. Featuring unforgettable songs such as 'Music of the Night' and 'All I Ask of You', this production has been wowing audiences for over 30 years. Don't miss your chance to see it live!",
  category_id: category_3.id,
  time_of_event: 21.days.from_now,
  approved: true
  ).first_or_create
  
event_10 = Event.where(
  user_id: user_advertiser2.id,
  name: "Summer Music Festival",
  address_line1: 'Victoria Park',
  town: 'Leicester',
  postcode: 'LE1 7RY',
  latitude: 52.636847,
  longitude: -1.141858,
  description: "Get ready for a day of fantastic live music at the Summer Music Festival! Featuring some of the UK's best up-and-coming artists, as well as established favourites, this festival promises to be a day to remember. Enjoy the sunshine (fingers crossed!) with a cold drink in hand, and let the music transport you to another world. With food stalls, crafts and activities for all ages, this is a perfect family day out.",
  category_id: category_4.id,
  time_of_event: 35.days.from_now,
  approved: true
  ).first_or_create
      
event_11 = Event.where(
  user_id: user_advertiser1.id,
  name: "Six Nations Rugby: Scotland vs Wales",
  address_line1: 'Murrayfield Stadium',
  town: 'Edinburgh',
  postcode: 'EH12 5PJ',
  latitude: 55.942137,
  longitude: -3.240835,
  description: "Get ready for an electrifying match as Scotland take on Wales in the Six Nations rugby tournament. Watch as two of the sport's top teams battle it out on the field, with tackles, tries and all the excitement you could want. With a buzzing atmosphere in the stands, and food and drink available to keep you fuelled, this is a must-see event for all rugby fans.",
  category_id: category_5.id,
  time_of_event: 42.days.from_now,
  approved: true
  ).first_or_create

event_12 = Event.where(
  user_id: user_advertiser1.id,
  name: "Comedy Night at The Stand",
  address_line1: '31 High Bridge',
  town: 'Newcastle upon Tyne',
  postcode: 'NE1 1EW',
  latitude: 54.9698657,
  longitude: -1.6108123,
  description: "Get ready to laugh until your sides ache at The Stand comedy club. Featuring some of the funniest comedians on the UK circuit, this is the perfect way to let off steam and have a good time. With a fully stocked bar and delicious snacks available, settle in for an evening of hilarity that you won't forget anytime soon.",
  category_id: category_1.id,
  time_of_event: 28.days.from_now,
  approved: true
  ).first_or_create

EventReact.where(
  user_id: user_admin1.id,
  event_id: event_4.id
).first_or_create

EventReact.where(
  user_id: user_admin2.id,
  event_id: event_4.id
).first_or_create

EventReact.where(
  user_id: user_advertiser1.id,
  event_id: event_4.id
).first_or_create

EventReact.where(
  user_id: user_user2.id,
  event_id: event_4.id
)
EventReact.where(
  user_id: user_user1.id,
  event_id: event_5.id
).first_or_create

EventReact.where(
  user_id: user_user1.id,
  event_id: event_1.id
).first_or_create

EventReact.where(
  user_id: user_user1.id,
  event_id: event_2.id
).first_or_create

EventReact.where(
  user_id: user_user1.id,
  event_id: event_3.id
).first_or_create

EventReact.where(
  user_id: user_user1.id,
  event_id: event_5.id
).first_or_create

EventReact.where(
  user_id: user_user1.id,
  event_id: event_6.id
).first_or_create

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

ProposedEvent.where(
  outing_id: outing1.id,
  event_id: event_1.id,
  proposed_datetime: 1.week.from_now
).first_or_create

ProposedEvent.where(
  outing_id: outing1.id,
  event_id: event_2.id,
  proposed_datetime: 1.week.from_now + 1.hour
).first_or_create

participant_outing1_1 = Participant.where(
  user_id: user_user1.id,
  outing_id: outing1,
  status: Participant.statuses[:creator]
).first_or_create

participant_outing1_2 = Participant.where(
  user_id: user_user2.id,
  outing_id: outing1,
  status: Participant.statuses[:pending]
).first_or_create

participant_outing3_1 = Participant.where(
  user_id: user_user2.id,
  outing_id: outing3,
  status: Participant.statuses[:creator]
).first_or_create

participant_outing3_2 = Participant.where(
  user_id: user_user1.id,
  outing_id: outing3,
  status: Participant.statuses[:pending]
).first_or_create

participant_outing2_1 = Participant.where(
  user_id: user_user1.id,
  outing_id: outing2,
  status: Participant.statuses[:creator]
).first_or_create

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