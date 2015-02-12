module DisruptionFilterParams
  extend ActiveSupport::Concern

  def filter_params
    dates_filter = params[:filter]

    if dates_filter
      if dates_filter[:dates].present?
        case dates_filter[:dates]
        when 'all'
          { :from => Date.parse('2014-01-01'), :to => today }

        when 'from_semester_begin'
          { :from => semester_begin, :to => today }

        when 'last_week'
          { :from => last_week_begin, :to => last_week_end }
        end
      elsif dates_filter[:from] && dates_filter[:to]
        { :from => dates_filter[:from].presence.to_date, :to => dates_filter[:to].presence.to_date }
      end
    else
      { :from => last_week_begin.to_date, :to => last_week_end.to_date }
    end
  end
end
