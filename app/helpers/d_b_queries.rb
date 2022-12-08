module DBQueries
  def getNumberOfVisits(metrics, startDateTime, endDateTime)
    if startDateTime && endDateTime
      metrics = metrics.where("time_enter >= :startDateTime and time_enter <= :endDateTime", {startDateTime: startDateTime, endDateTime: endDateTime})
    end
    return metrics.count()
  end
    
  def getNumberOfInteractionsPerVisit(metrics, startDateTime, endDateTime)
    # Returns the NumberOfInteractionsPerVisit
    if startDateTime && endDateTime
      metrics = metrics.where("time_enter >= :startDateTime and time_enter <= :endDateTime", {startDateTime: startDateTime, endDateTime: endDateTime})
    end
    if metrics.count() == 0
      return 0
    else
      return (metrics.sum(:number_interactions)/metrics.count()).to_s
    end
  end

  def getAverageTimeSpent(metrics, startDateTime, endDateTime)
    if startDateTime && endDateTime
      metrics = metrics.where("time_enter >= :startDateTime and time_enter <= :endDateTime", {startDateTime: startDateTime, endDateTime: endDateTime})
    end

    numMetrics = metrics.count()
    averageTimeSpent = 0
    metrics.pluck(:time_enter).lazy.zip(metrics.pluck(:time_exit)).each do |enterTime, exitTime|
      averageTimeSpent += ((exitTime - enterTime)/numMetrics)
    end
    return averageTimeSpent
  end

  def getHumanReadableAverageTimeSpent(metrics, startDateTime, endDateTime)
    # Average time spent on page in h:m:s format. If more than 24 hours, instead return string "More than a day" 
    averageTimeSpent = getAverageTimeSpent(metrics, startDateTime, endDateTime)

    if averageTimeSpent > 86400
      averageTimeSpent = "More than a day"
    else
      averageTimeSpent = "%02d:%02d:%02d" % [averageTimeSpent / 3600, averageTimeSpent / 60 % 60, averageTimeSpent % 60]
    end
    return averageTimeSpent
  end
  
  def getPricingInterest(register_interests, selected_pricing, startDateTime, endDateTime)
    register_interests = register_interests.where(pricing_id: selected_pricing)
    if startDateTime && endDateTime
      register_interests = register_interests.where("created_at >= :startDateTime and created_at <= :endDateTime", {startDateTime: startDateTime, endDateTime: endDateTime})
    end

    return register_interests.count()
  end

  def getNumberPricingPageBounceOuts(metrics, register_interests, startDateTime, endDateTime)
    puts metrics
    puts register_interests
    if startDateTime && endDateTime
      register_interests = register_interests.where("created_at >= :startDateTime and created_at <= :endDateTime", {startDateTime: startDateTime, endDateTime: endDateTime})
      metrics = metrics.where("time_enter >= :startDateTime and time_enter <= :endDateTime and route = '/pricings'", {startDateTime: startDateTime, endDateTime: endDateTime})
    else
      metrics = metrics.where("route = '/pricings'")
    end

    return metrics.count() - register_interests.count()
  end

  def getCommonMetrics(metrics, numMetrics)

    numberOfVisits = getNumberOfVisits(metrics, nil, nil)
    numberOfInteractionsPerVisit = getNumberOfInteractionsPerVisit(metrics, nil, nil)
    averageTimeSpent = getHumanReadableAverageTimeSpent(metrics, nil, nil)

    return [
      ["# visits", numberOfVisits],
      ["x̄ # clicks/visit", numberOfInteractionsPerVisit],
      ["x̄ time on page", averageTimeSpent],
    ]
  end
end
