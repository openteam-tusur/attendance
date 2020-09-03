module DateRange
  def semester_begin
    if current_month > 6
      Date.parse(%{#{current_year}-09-01})
    else
      Date.parse(%{#{current_year}-01-01})
    end
  end

  def today
    Date.today
  end

  def semester_end
    today
  end

  def last_day_needed_to_fill
    Time.zone.now.hour >= 9 ? today : today - 1.days
  end

  def last_week_begin
    today.beginning_of_week - 7.day
  end

  def last_week_end
    today.beginning_of_week - 1.day
  end

  def current_month
    today.month
  end

  def current_year
    today.year
  end
end
