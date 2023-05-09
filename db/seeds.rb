# frozen_string_literal: true

default_password = 'SneakyPassword100'

print 'creating users'
print '.'
user_admin1 = User.where(email: 'admin1@planetgo.com')
                  .first_or_create(
                    role: User.roles[:admin],
                    password: default_password,
                    full_name: 'Arielle Norman'
                  )
print '.'

user_admin2 = User.where(email: 'admin2@planetgo.com')
                  .first_or_create(
                    role: User.roles[:admin],
                    password: default_password,
                    full_name: 'Miguel Whitaker'
                  )

print '.'
user_advertiser1 = User.where(email: 'advertiser1@company.com')
                       .first_or_create(
                         role: User.roles[:advertiser],
                         password: default_password,
                         full_name: 'Billy Adams'
                       )

print '.'
user_advertiser2 = User.where(email: 'advertiser2@company.com')
                       .first_or_create(
                         role: User.roles[:advertiser],
                         password: default_password,
                         full_name: 'Mango Cavern'
                       )

print '.'

user_advertiser3 = User.where(email: 'advertiser3@hotels.com')
                       .first_or_create(
                          role: User.roles[:advertiser],
                          password: default_password,
                          full_name: 'Hotel California'
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

full_names = ['John Doe', 'Jane Doe', 'Bob Smith', 'Alice Johnson', 'Michael Brown', 'Emily Davis', 'David Lee', 'Megan Wilson', 'Samuel Jones', 'Olivia Martin', 'Matthew Clark',
              'Ella Wright']
postcodes = ['SW1A 0AA', 'EC1A 1BB', 'W1D 3QU', 'SE10 0BB', 'B1 2HF', 'WC2N 5DU', 'EH1 1QB', 'LS1 4BR', 'L1 8JQ', 'M60 7RA', 'BN1 1AA', 'OX1 2PL']
user_list = []

full_names.each_with_index do |_full_name, index|
  user_list << (
      User.where(email: "user#{index + 1}@gmail.com").first_or_create(
        role: User.roles[:user],
        password: default_password,
        full_name: full_names[index],
        postcode: postcodes[index]
      )
    )
  print '.'

end

def make_friend(user_sending, user_receiving)
  print '.'
  user_sending.send_follow_request_to(user_receiving)
  user_receiving.accept_follow_request_of(user_sending)

  user_receiving.send_follow_request_to(user_sending)
  user_sending.accept_follow_request_of(user_receiving)
end

puts ''
print 'creating friends'
make_friend(user_list[0], user_list[1])
make_friend(user_list[0], user_list[2])
make_friend(user_list[0], user_list[3])
make_friend(user_list[1], user_list[2])
make_friend(user_list[1], user_list[3])
make_friend(user_list[2], user_list[3])
make_friend(user_list[0], user_rep1)
make_friend(user_list[0], user_rep2)
make_friend(user_list[0], user_advertiser1)
make_friend(user_list[0], user_advertiser2)
make_friend(user_list[1], user_rep1)
make_friend(user_list[1], user_rep2)

puts ''
print 'creating categories'

category_bar = Category.first_or_create(
  name: 'bar',
  symbol: '🍺'
)
print '.'

category_restaurant = Category.where(
  name: 'restaurant'
).first_or_create

category_accommodation = Category.where(
  name: 'accommodation',
  symbol: '🍽️'
).first_or_create

print '.'

category_theatre = Category.where(
  name: 'theatre',
  symbol: '🎭'
).first_or_create
print '.'

category_music = Category.where(
  name: 'music',
  symbol: '🎵'
).first_or_create
print '.'

category_sports = Category.where(
  name: 'sports',
  symbol: '⚽'
).first_or_create

event_list = []
puts ''
print 'creating events'

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
  time_of_event: 7.days.from_now,
  colour: 1
).first_or_create

print '.'
event_2 = Event.where(
  user_id: user_advertiser1.id,
  name: "Billy's Pasta tasting",
  description: "I'll be honest, even I wouldn't eat the food we serve",
  address_line1: '9273 London Road',
  town: 'Romford',
  postcode: 'SW1A 0AA',
  latitude: 51.4998,
  longitude: -0.1247,
  category_id: category_restaurant.id,
  time_of_event: 7.days.from_now,
  colour: 2
).first_or_create

print '.'
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
  approved: true,
  colour: 3
).first_or_create

print '.'
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
  approved: true,
  colour: 4
).first_or_create

print '.'
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
  approved: true,
  colour: 5
).first_or_create

print '.'
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
  approved: true,
  colour: 6
).first_or_create

print '.'
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
  approved: true,
  colour: 7
).first_or_create

print '.'
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
  approved: true,
  colour: 8
).first_or_create

print '.'
event_9 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Music Festival',
  address_line1: 'Houses of Parliament',
  town: 'London',
  postcode: 'SW1A 1AA',
  latitude: 40.712776,
  longitude: -74.005974,
  description: 'A day-long festival featuring live music from local bands.',
  category_id: category_music.id,
  approved: true,
  colour: 9
).first_or_create

print '.'
event_10 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Art Show',
  address_line1: '456 Elm Street',
  town: 'Shelbyville',
  postcode: 'B1 1BB',
  latitude: 41.878113,
  longitude: -87.629799,
  description: 'An exhibition of paintings and sculptures by local artists.',
  category_id: category_music.id,
  approved: true,
  colour: 10
).first_or_create

print '.'
event_11 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Food Festival',
  address_line1: '9273 London Road',
  town: 'Romford',
  postcode: 'SW1A 0AA',
  latitude: 51.4998,
  longitude: -0.1247,
  description: 'A celebration of local cuisine with food stalls and cooking demonstrations.',
  category_id: category_restaurant.id,
  approved: true,
  colour: 11
).first_or_create

print '.'
event_12 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Book Fair',
  address_line1: '321 Maple Street',
  town: 'Ogdenville',
  postcode: 'CF10 1BH',
  latitude: 42.360081,
  longitude: -71.058884,
  description: 'A gathering of booksellers and publishers with book signings and readings.',
  category_id: category_theatre.id,
  approved: true,
  colour: 1
).first_or_create

print '.'
event_13 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Film Festival',
  address_line1: '159 Hollywood Boulevard',
  town: 'Los Angeles',
  postcode: 'BT1 5GS',
  latitude: 34.0928092,
  longitude: -118.3286614,
  description: 'A week-long festival showcasing independent films from around the world.',
  category_id: category_music.id,
  approved: true,
  colour: 2
).first_or_create

print '.'
event_14 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Comedy Night',
  address_line1: '753 Broadway Street',
  town: 'New York City',
  postcode: 'LS1 1UR',
  latitude: 40.7322535,
  longitude: -73.9874105,
  description: 'A night of stand-up comedy featuring local comedians.',
  category_id: category_bar.id,
  approved: true,
  colour: 3
).first_or_create

print '.'
event_15 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Farmers Market',
  address_line1: '246 Rural Road',
  town: 'Smallville',
  postcode: 'G1 1XU',
  latitude: 38.2544472,
  longitude: -85.7591230,
  description: 'A weekly market featuring fresh produce and handmade goods from local farmers and artisans.',
  category_id: category_restaurant.id,
  approved: true,
  colour: 4
).first_or_create

print '.'
event_16 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Craft Fair',
  address_line1: '369 Main Street',
  town: 'Riverdale',
  postcode: 'NE1 6EE',
  latitude: 41.1536674,
  longitude: -73.2829269,
  description: 'A fair showcasing handmade crafts and goods from local artisans.',
  category_id: category_sports.id,
  approved: true,
  colour: 5
).first_or_create

print '.'
event_17 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Wine Tasting',
  address_line1: '654 Vineyard Lane',
  town: 'Napa',
  postcode: 'L1 8JQ',
  latitude: 38.5024689,
  longitude: -122.2653887,
  description: 'An evening of wine tasting featuring local wineries.',
  category_id: category_bar.id,
  approved: true,
  colour: 6
).first_or_create

print '.'
event_18 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Taste of India pop-up restaurant',
  address_line1: '71 High Street',
  town: 'Birmingham',
  postcode: 'B17 9NS',
  latitude: 52.4581445,
  longitude: -1.9795945,
  description: "Come and experience the flavours of India at our pop-up restaurant. Our talented chefs have created a delicious menu featuring a range of traditional dishes and modern twists. Start with our spicy samosas or tangy chaat, before moving on to our rich curries and biryanis. And don't forget to leave room for our decadent desserts! Our pop-up is only open for a limited time, so book your table now to avoid disappointment.",
  category_id: category_restaurant.id,
  time_of_event: 14.days.from_now,
  approved: true,
  colour: 7
).first_or_create

print '.'
event_19 = Event.where(
  user_id: user_advertiser1.id,
  name: 'The Phantom of the Opera',
  address_line1: 'Shaftesbury Avenue',
  town: 'London',
  postcode: 'W1D 7EZ',
  description: "Experience the magic of The Phantom of the Opera at Her Majesty's Theatre. This timeless musical tells the story of a mysterious figure who haunts the Paris Opera House, and the young soprano who becomes his obsession. Featuring unforgettable songs such as 'Music of the Night' and 'All I Ask of You', this production has been wowing audiences for over 30 years. Don't miss your chance to see it live!",
  category_id: category_theatre.id,
  time_of_event: 21.days.from_now,
  approved: true,
  colour: 8
).first_or_create

print '.'
event_20 = Event.where(
  user_id: user_advertiser2.id,
  name: 'Summer Music Festival',
  address_line1: 'Shaftesbury Avenue',
  town: 'London',
  postcode: 'W1D 7EZ',
  latitude: 52.636847,
  longitude: -1.141858,
  description: "Get ready for a day of fantastic live music at the Summer Music Festival! Featuring some of the UK's best up-and-coming artists, as well as established favourites, this festival promises to be a day to remember. Enjoy the sunshine (fingers crossed!) with a cold drink in hand, and let the music transport you to another world. With food stalls, crafts and activities for all ages, this is a perfect family day out.",
  category_id: category_music.id,
  time_of_event: 35.days.from_now,
  approved: true,
  colour: 9
).first_or_create

print '.'
event_21 = Event.where(
  user_id: user_advertiser1.id,
  name: 'Six Nations Rugby: Scotland vs Wales',
  address_line1: 'Shaftesbury Avenue',
  town: 'London',
  postcode: 'W1D 7EZ',
  latitude: 55.942137,
  longitude: -3.240835,
  description: "Get ready for an electrifying match as Scotland take on Wales in the Six Nations rugby tournament. Watch as two of the sport's top teams battle it out on the field, with tackles, tries and all the excitement you could want. With a buzzing atmosphere in the stands, and food and drink available to keep you fuelled, this is a must-see event for all rugby fans.",
  category_id: category_sports.id,
  time_of_event: 42.days.from_now,
  approved: true,
  colour: 10
).first_or_create

print '.'
event_22 = Event.where(
  user_id: user_advertiser1.id,
  name: 'Comedy Night at The Stand',
  address_line1: '31 High Bridge',
  town: 'Newcastle upon Tyne',
  postcode: 'NE1 1EW',
  latitude: 54.9698657,
  longitude: -1.6108123,
  description: "Get ready to laugh until your sides ache at The Stand comedy club. Featuring some of the funniest comedians on the UK circuit, this is the perfect way to let off steam and have a good time. With a fully stocked bar and delicious snacks available, settle in for an evening of hilarity that you won't forget anytime soon.",
  category_id: category_bar.id,
  time_of_event: 28.days.from_now,
  approved: true,
  colour: 11
).first_or_create

print '.'
event_23 = Event.where(
  user_id: user_advertiser1.id,
  name: 'The Golden Lion Pub Quiz',
  address_line1: '36 York Street',
  town: 'Norwich',
  postcode: 'NR2 2DU',
  latitude: 52.6266995,
  longitude: 1.2927062,
  description: 'Come along to The Golden Lion pub and join in our weekly quiz. Test your knowledge with our fun and challenging questions, while enjoying a pint of our locally brewed beer. Our quiz is free to enter, and the winning team receives a £50 bar tab. Plus, we have plenty of other prizes up for grabs throughout the night. So gather your friends and come along for a great evening of fun and games!',
  category_id: category_bar.id,
  time_of_event: 10.days.from_now,
  approved: true,
  colour: 0
).first_or_create
print '.'




accom_1 = Event.where(
  user_id: user_advertiser3.id,
  name: 'Youth Hostel',
  address_line1: '9273 London Road',
  town: 'Romford',
  postcode: 'SW1A 0AA',
  latitude: 51.4998,
  longitude: -0.1247,
  description: "Looking for a place to stay in Romford? Look no further than the Youth Hostel. With comfortable rooms, a friendly atmosphere and a great location, this is the perfect base for exploring the city. We offer a range of accommodation options, from dorms to private rooms, so there's something for everyone. Plus, we have a bar and restaurant on site, so you can enjoy a drink or a meal after a long day of sightseeing. Book your stay today!",
  category_id: category_accommodation.id,
  time_of_event: nil,
  approved: true
).first_or_create

print '.'

accom_2 = Event.where(
  user_id: user_advertiser3.id,
  name: 'Airbnb',
  address_line1: 'Aberdeen Street',
  town: 'Glasgow',
  postcode: 'G12 8RT',
  latitude: 55.872084,
  longitude: -4.288721,
  description: "Looking for a place to stay in Glasgow? Look no further than Airbnb. We have a wide range of accommodation options, from apartments to houses, so you can find the perfect place for your stay. Plus, we offer a range of amenities to make your stay as comfortable as possible, including free wifi and a fully equipped kitchen. So whether you're looking for a place to stay for a night or a month, we've got you covered.",
  category_id: category_accommodation.id,
  time_of_event: nil,
  approved: true
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
  [18, 13]
]

puts ''
print 'creating event reacts'

random_event_and_user_pairs.each do |pair|
  print '.'
  user_id = pair[0]
  event_id = pair[1]

  EventReact.where(
    user_id:,
    event_id:
  ).first_or_create
end

puts ''
print 'creating outings'

outing1 = Outing.where(
  name: 'Pizza Time',
  description: 'Pizza Time is an outing centered around indulging in delicious, freshly made pizzas with a group of friends or family. It is an opportunity to explore different pizza places, try new toppings and flavors, and bond over the love of pizza.',
  date: 1.week.from_now,
  creator_id: user_list[0].id,
  outing_type: :personal
).first_or_create

print '.'
outing2 = Outing.where(
  name: 'Sunset Hike',
  description: 'Join us for a beautiful evening hike as we watch the sun go down over the mountains. This moderate-level hike will take approximately 2 hours and cover 4 miles.',
  date: 2.weeks.from_now,
  creator_id: user_list[0].id,
  outing_type: :open
).first_or_create

print '.'
outing3 = Outing.where(
  name: 'Bar Crawl',
  description: 'The crawl will visit a total of 5 bars and clubs throughout the night, each with its unique atmosphere and drink specials. ',
  date: 1.week.ago,
  creator_id: user_list[1].id,
  outing_type: :open
).first_or_create

print '.'
outing4 = Outing.where(
  name: 'Movie Night',
  description: 'The movie night takes place in a cozy indoor setting, with comfortable couches and chairs arranged around a large screen. The room is dimly lit, creating a relaxed and inviting atmosphere. Snacks and drinks are provided, including popcorn, candy, and soda. A selection of classic movies is available to choose from, ranging from romantic comedies to action-packed blockbusters. Before the movie begins, attendees can chat and mingle with one another, discussing their favorite films and making new friends. As the lights dim and the movie starts, everyone settles in for a fun and entertaining evening.',
  date: 3.weeks.from_now,
  creator_id: user_list[1].id,
  outing_type: :personal
).first_or_create

print '.'
outing5 = Outing.where(
  name: 'Pub Quiz',
  description: 'The pub quiz involves participants competing in a battle of wits to see who can answer the most questions correctly. Tthe quiz consists of a series of rounds that cover a variety of topics ranging from pop culture to history and science. The quiz is open to teams of up to six people, and each round is composed of ten challenging questions. ',
  date: 2.weeks.from_now,
  creator_id: user_list[2].id,
  outing_type: :personal
).first_or_create

outing_list = [outing1, outing2, outing3, outing4, outing5]

puts ''
print 'creating participants (creators)'

# create participants for every creator of every outing
outing_list.each do |outing|
  print '.'
  Participant.where(
    user_id: outing.creator_id,
    outing_id: outing.id,
    status: 'creator'
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
  (3.months + 1.day).from_now + 18.hours,
  (4.months + 2.weeks).from_now + 19.hours
]

outing_list = [outing3, outing1, outing4, outing2, outing5, outing2, outing1, outing3, outing5, outing4, outing2, outing1, outing4, outing3, outing5, outing1, outing2]
event_list = [event_1, event_2, event_3, event_4, event_5, event_6, event_7, event_8, event_9, event_10, event_11, event_12, event_13, event_14, event_15, event_16, event_17]

puts ''
print 'creating proposed events'

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

puts ''
print 'creating participants'

participant_zips.each do |user_id, outing|
  print '.'
  status = 'confirmed'

  # random but reproducible pending requests
  status = 'pending' if (user_id + (outing.id % 2)).zero?

  status = 'creator' if outing.creator_id == user_id

  Participant.where(
    user_id: user_id,
    outing_id: outing.id,
    status: status
  ).first_or_create
end

puts ''
print 'creating proposed event votes'

outing_list.each do |outing|
  participant_count = outing.participants.count

  outing.participants.each_with_index do |participant, index|
    user = participant.user
    print '.'
    outing.proposed_events.first.liked_by user

    if index < participant_count * 0.8
      print '.'
      outing.proposed_events.second.liked_by user
    end

    if index < participant_count * 0.4
      print '.'
      outing.proposed_events.third.liked_by user
    end
  end
end

puts ''
print 'creating metrics'

metric_1 = Metric.where(
  time_enter: '2022-11-25 12:24:16', time_exit: '2022-11-25 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 4
).first_or_create

print '.'
metric_6 = Metric.where(
  time_enter: '2022-11-25 12:24:16', time_exit: '2022-11-25 12:25:16', route: '/', latitude: 39.341952,
  longitude: -93.907174, country_code: 'US', is_logged_in: false, number_interactions: 1
).first_or_create

print '.'
metric_7 = Metric.where(
  time_enter: '2022-11-26 12:24:16', time_exit: '2022-11-26 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'CN', is_logged_in: false, number_interactions: 0
).first_or_create

print '.'
metric_8 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'RU', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_9 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_10 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AF', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_11 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AD', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_12 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'AW', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_13 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'GB', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_14 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'EG', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_15 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IE', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_16 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'ML', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_17 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'YT', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_18 = Metric.where(
  time_enter: '2022-11-27 12:24:16', time_exit: '2022-11-27 12:25:16', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_19 = Metric.where(
  time_enter: '2022-11-27 12:24:17', time_exit: '2022-11-27 12:25:17', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_20 = Metric.where(
  time_enter: '2022-11-27 12:24:18', time_exit: '2022-11-27 12:25:18', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5
).first_or_create

print '.'
metric_21 = Metric.where(
  time_enter: '2022-11-27 12:24:19', time_exit: '2022-11-27 12:25:19', route: '/', latitude: 53.376347,
  longitude: -1.488364, country_code: 'IN', is_logged_in: false, number_interactions: 5
).first_or_create
