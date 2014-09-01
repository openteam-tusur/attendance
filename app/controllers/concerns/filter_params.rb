module FilterParams
  extend ActiveSupport::Concern

  def filter_params
    case params[:filter]
    when 'all'
      { :from => Date.parse('2014-01-01'), :to => today }

    when 'from_semester_begin'
      { :from => semester_begin, :to => last_week_end }

    when 'last_week', nil
      { :from => last_week_begin, :to => last_week_end }

    else
      from = (params[:filter][:from].presence || last_week_begin)
      to = (params[:filter][:to].presence     || last_week_end)
      { :from => from.to_date, :to => to.to_date }
    end
  end
end
