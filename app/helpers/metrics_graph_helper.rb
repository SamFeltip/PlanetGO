# frozen_string_literal: true

module MetricsGraphHelper
  include DBQueries
  def handle_graph(start_param, end_param, resolution_param, page_param, metric_param)
    start_date_array = start_param.split('-')
    end_date_array = end_param.split('-')

    # Calculate start end Time objects. Default is one month ago and now respectively
    start_date_time_stamp = 1.month.ago
    end_date_time_stamp = Time.zone.now
    if start_date_array.length == 3
      start_date_time_stamp = Time.zone.local(start_date_array[0], start_date_array[1], start_date_array[2])
    end
    if end_date_array.length == 3
      end_date_time_stamp = Time.zone.local(end_date_array[0], end_date_array[1], end_date_array[2])
    end

    # Get date increment from params. Default is one day if no param passed
    date_increment = case resolution_param
                     when 'Month'
                       1.month
                     when 'Year'
                       1.year
                     else
                       1.day
                     end
    Rails.logger.debug date_increment

    register_interests = RegisterInterest.all
    metrics = page_param ? Metric.where(route: page_param) : Metric.where(route: '/')

    data_keys = []
    data_values = []

    # TODO: Is there a way to make this more DRY?
    case metric_param
    when '# visits', 'Total number of landing page visits'
      data = []
      while start_date_time_stamp < end_date_time_stamp
        data_keys.append(start_date_time_stamp.strftime('%F'))
        data.append(get_number_of_visits(metrics, start_date_time_stamp, start_date_time_stamp + date_increment))
        start_date_time_stamp += date_increment
      end

      data_values = JSON.generate([{ label: '# visits', data: }])
    when 'x̄ # clicks/visit'
      data = []
      while start_date_time_stamp < end_date_time_stamp
        data_keys.append(start_date_time_stamp.strftime('%F'))
        data.append(get_number_of_interactions_per_visit(metrics, start_date_time_stamp,
                                                         start_date_time_stamp + date_increment))
        start_date_time_stamp += date_increment
      end

      data_values = JSON.generate([{ label: 'x̄ # clicks/visit', data: }])
    when 'x̄ time on page'
      data = []
      while start_date_time_stamp < end_date_time_stamp
        data_keys.append(start_date_time_stamp.strftime('%F'))
        data.append(get_average_time_spent(metrics, start_date_time_stamp, start_date_time_stamp + date_increment))
        start_date_time_stamp += date_increment
      end

      data_values = JSON.generate([{ label: 'x̄ time on page', data: }])
    when 'Pricing page bounce outs'
      data = []
      while start_date_time_stamp < end_date_time_stamp
        data_keys.append(start_date_time_stamp.strftime('%F'))
        data.append(get_number_pricing_page_bounce_outs(metrics, register_interests, start_date_time_stamp,
                                                        start_date_time_stamp + date_increment))
        start_date_time_stamp += date_increment
      end

      data_values = JSON.generate([{ label: 'Pricing page bounce outs', data: }])
    when 'Interest in pricing options Basic:Premium:Premium+ Total'
      pricing_interest = RegisterInterest.all
      basic = []
      premium = []
      premium_plus = []
      while start_date_time_stamp < end_date_time_stamp
        data_keys.append(start_date_time_stamp.strftime('%F'))
        basic.append(get_pricing_interest(pricing_interest, 'basic', start_date_time_stamp,
                                          start_date_time_stamp + date_increment))
        premium.append(get_pricing_interest(pricing_interest, 'premium', start_date_time_stamp,
                                            start_date_time_stamp + date_increment))
        premium_plus.append(get_pricing_interest(pricing_interest, 'premium_plus', start_date_time_stamp,
                                                 start_date_time_stamp + date_increment))
        start_date_time_stamp += date_increment
      end
      data_values = JSON.generate([{ label: 'Basic', data: basic }, { label: 'Premium', data: premium },
                                   { label: 'Premium+', data: premium_plus }])
    when 'Interest in pricing options Basic:Premium:Premium+ Percent'
      pricing_interest = RegisterInterest.all
      basic = []
      premium = []
      premium_plus = []
      while start_date_time_stamp < end_date_time_stamp
        data_keys.append(start_date_time_stamp.strftime('%F'))
        basic_value = get_pricing_interest(pricing_interest, 'basic', start_date_time_stamp,
                                           start_date_time_stamp + date_increment)
        premium_value = get_pricing_interest(pricing_interest, 'premium', start_date_time_stamp,
                                             start_date_time_stamp + date_increment)
        premium_plus_value = get_pricing_interest(pricing_interest, 'premium_plus', start_date_time_stamp,
                                                  start_date_time_stamp + date_increment)
        total = basic_value + premium_value + premium_plus_value
        total = 1 if total.zero?

        basic.append((basic_value * 100) / total)
        premium.append((premium_value * 100) / total)
        premium_plus.append((premium_plus_value * 100) / total)

        start_date_time_stamp += date_increment
      end
      data_values = JSON.generate([{ label: 'Basic', data: basic }, { label: 'Premium', data: premium },
                                   { label: 'Premium+', data: premium_plus }])
    else
      # No metric selected by the user, display a slash accross the graph with a label "No Data"
      empty_graph
    end

    [data_keys, data_values]
  end

  def empty_graph
    [[0, 1], JSON.generate([{ label: 'No Data', data: [1, 0] }])]
  end
end
