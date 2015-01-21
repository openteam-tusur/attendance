module DateRange
  def semester_begin
    #if current_month > 6
      Date.new(current_year, 7, 1)
    #else
      #Date.new(current_year, 1, 1)
    #end
  end

  def semester_end
    today
  end

  def last_week_begin
    today.beginning_of_week - 7.day
  end

  def last_week_end
    today.beginning_of_week - 1.day
  end

  def today
    @today ||= Time.zone.parse('2014-10-24')#Date.today
  end

  def current_month
    @current_month ||= 10#today.month
  end

  def current_year
    @current_year ||= today.year-1
  end
end
