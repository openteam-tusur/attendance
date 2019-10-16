module FilterParams
  extend ActiveSupport::Concern

  def filter_params
    case params[:filter]
    when 'all'
      {
        from: Date.parse('2014-01-01'),
        to: today
      }
    when 'from_semester_begin'
      {
        from: semester_begin,
        to: today
      }
    when 'last_week', nil
      {
        from: last_week_begin,
        to: last_week_end
      }
    else
      {
        from: (params[:filter][:from].to_date rescue last_week_begin),
        to: (params[:filter][:to].to_date rescue last_week_end)
      }
    end
  end
end
