# frozen_string_literal: true

module DBQueries
  def get_number_of_visits(metrics, start_date_time, end_date_time)
    if start_date_time && end_date_time
      metrics = metrics.where('time_enter >= :start_date_time and time_enter <= :end_date_time',
                              { start_date_time:, end_date_time: })
    end
    metrics.count
  end

  def get_number_of_interactions_per_visit(metrics, start_date_time, end_date_time)
    # Returns the number_of_interactions_per_visit
    if start_date_time && end_date_time
      metrics = metrics.where('time_enter >= :start_date_time and time_enter <= :end_date_time',
                              { start_date_time:, end_date_time: })
    end
    return 0 if metrics.count.zero?

    (metrics.sum(:number_interactions) / metrics.count).to_s
  end

  def get_event_category_popularity(name, start_date_time, end_date_time)
    ProposedEvent.joins(event: :category).where('categories.name = :name and proposed_events.proposed_datetime >= :start_date_time and proposed_events.proposed_datetime < :end_date_time',
                                                { name:, start_date_time:, end_date_time: }).count
  end

  def get_average_time_spent(metrics, start_date_time, end_date_time)
    if start_date_time && end_date_time
      metrics = metrics.where('time_enter >= :start_date_time and time_enter <= :end_date_time',
                              { start_date_time:, end_date_time: })
    end

    num_metrics = metrics.count
    average_time_spent = 0
    metrics.pluck(:time_enter).lazy.zip(metrics.pluck(:time_exit)).each do |enter_time, exit_time|
      average_time_spent += ((exit_time - enter_time) / num_metrics)
    end
    average_time_spent
  end

  def get_human_readable_average_time_spent(metrics, start_date_time, end_date_time)
    # Average time spent on page in h:m:s format. If more than 24 hours, instead return string "More than a day"
    average_time_spent = get_average_time_spent(metrics, start_date_time, end_date_time)

    if average_time_spent > 86_400
      'More than a day'
    else
      format('%02d:%02d:%02d', average_time_spent / 3600, average_time_spent / 60 % 60,
             average_time_spent % 60)
    end
  end

  def get_common_metrics(metrics)
    number_of_visits = get_number_of_visits(metrics, nil, nil)
    number_of_interactions_per_visit = get_number_of_interactions_per_visit(metrics, nil, nil)
    average_time_spent = get_human_readable_average_time_spent(metrics, nil, nil)

    [
      ['# visits', number_of_visits],
      ['x̄ # clicks/visit', number_of_interactions_per_visit],
      ['x̄ time on page', average_time_spent]
    ]
  end
end
