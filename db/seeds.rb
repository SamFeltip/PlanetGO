# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

FactoryBot.create(:user, role: 2)

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