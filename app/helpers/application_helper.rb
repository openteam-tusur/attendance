module ApplicationHelper
  def document_title
    [I18n.t('site'), page_title].compact.join(' | ')
  end

  def page_title(title = nil)
    @page_title ||= I18n.t("page_title.#{controller_name}.#{action_name}", :title => title).html_safe
  end

  def render_menu(context)
    render_navigation(:context => context)
  end

  def current_namespace
    controller_path.split('/')[-2].try(:to_sym)
  end

  def day_classes(groupped_lessons, day)
    realized_lessons_by_date = groupped_lessons[day].select{|l| l.realizes.first.state == 'was'}

    classes = ['day']

    if realized_lessons_by_date.select{ |l| l.presences.map(&:state).include?(nil) }.any?
      classes << 'unfilled'
    else
      classes << 'filled'
    end

    classes << 'current' if day == @date

    classes.join(' ')
  end

  def calendar_months(date)
    if date.month >= 6
      ((date.beginning_of_year + 6.month)..date.end_of_year).group_by(&:month)
    else
      (date.beginning_of_year..(date.end_of_year - 6.month)).group_by(&:month)
    end
  end
end
