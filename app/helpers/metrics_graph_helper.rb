# frozen_string_literal: true

module MetricsGraphHelper
  include DBQueries
  def handle_graph_metric(start_param, end_param, resolution_param, page_param, metric_param)
    start_date_time_stamp, end_date_time_stamp = start_end_time_stamp(start_param, end_param)

    # Get date increment from params. Default is one day if no param passed
    date_increment = date_increment(resolution_param)

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

      data_values = JSON.generate([{ label: 'x̄ time on page (s)', data: }])
    else
      # No metric selected by the user, display a slash accross the graph with a label "No Data"
      empty_graph
    end

    [data_keys, data_values]
  end

  def handle_graph_category(start_param, end_param, resolution_param, category_param)
    start_date_time_stamp, end_date_time_stamp = start_end_time_stamp(start_param, end_param)

    # Get date increment from params. Default is one day if no param passed
    date_increment = date_increment(resolution_param)

    data_keys = []
    data_values = []

    # TODO: Is there a way to make this more DRY?
    case category_param
    when 'All'
      category_names = Category.distinct.pluck(:name)
      data_values = []
      # makes a new object for every category name containing the label and an array of integers
      category_names.each do |name|
        new_start_date_time_stamp = start_date_time_stamp
        data = []
        data_keys = []
        while new_start_date_time_stamp < end_date_time_stamp
          data_keys.append(new_start_date_time_stamp.strftime('%F'))
          data.append(get_event_category_popularity(name, new_start_date_time_stamp, new_start_date_time_stamp + date_increment))
          new_start_date_time_stamp += date_increment
        end

        data_values.append({ label: name, data: })
      end
    else
      # Particular category selected
      new_start_date_time_stamp = start_date_time_stamp
      data = []
      while new_start_date_time_stamp < end_date_time_stamp
        data_keys.append(new_start_date_time_stamp.strftime('%F'))
        data.append(get_event_category_popularity(category_param, new_start_date_time_stamp, new_start_date_time_stamp + date_increment))
        new_start_date_time_stamp += date_increment
      end

      data_values.append({ label: category_param, data: })
    end

    [JSON.generate(data_keys), JSON.generate(data_values)]
  end

  def start_end_time_stamp(start_param, end_param)
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

    [start_date_time_stamp, end_date_time_stamp]
  end

  def date_increment(resolution_param)
    case resolution_param
    when 'Month'
      1.month
    when 'Year'
      1.year
    else
      1.day
    end
  end

  def empty_graph
    [[0, 1], JSON.generate([{ label: 'No Data', data: [1, 0] }])]
  end
end
