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

  def date_filters
    param = params.try(:[], :filter)
    ''.tap do |s|
      s << content_tag(:div, :class => 'tabs btn-group') do
        ''.tap do |f|
          %w(from_semester_begin last_week).each do |item|
            f << link_to(I18n.t("filter_labels.#{item}"),
                         params.merge(:filter => item),
                         :class => "btn #{item} #{param == item || param == nil && item == 'last_week' ? 'active' : 'stub'}")
          end

          f << link_to(I18n.t("filter_labels.date_range"), '', :class => "btn js-date-range rounded #{param.is_a?(Hash) ? 'active' : 'stub'}")

          f << content_tag(:form, :class => 'date-range form-inline input-group hidden', :action => '') do
            ''.tap do |form|
              form << tag(:input, :type => :text,   :value => param.is_a?(Hash) ? param[:from] : nil, :name => 'filter[from]', :class => 'form-control input-sm datepicker', :placeholder => 'С')
              form << tag(:input, :type => :text,   :value => param.is_a?(Hash) ? param[:to]   : nil, :name => 'filter[to]', :class => 'form-control input-sm rounded datepicker', :placeholder => 'По')
              form << tag(:input, :type => :submit, :value => 'Фильтровать', :class => 'btn btn-default btn-sm')
            end.html_safe
          end
        end.html_safe
      end
    end.html_safe
  end

  def charts
    res = content_tag(:div, date_filters, :class => 'filters')

    (@charts || []).each do |kind, data|
      kind, chart_type = kind.split('.')
      res += content_tag(:h2, I18n.t("page_title.#{kind}"), :class => 'text-center')
      res += render_chart(chart_type, data)
    end

    res
  end

  def render_chart(kind, data)
    chart_id = "chart-#{incr_counter}"
    javascript_tag do
      res = ''
      res += "new #{kind.capitalize}Chart('#{chart_id}', #{data.to_json});"
      res.html_safe
    end +
    content_tag(:div, '', :class => 'chart_wrapper', :id => chart_id)
  end

  def line_chart(data)
    render_chart('line', data)
  end

  def bar_chart(data)
    render_chart('bar', data)
  end

  def link_to_back
    link_to I18n.t('filter_labels.back').html_safe, @parent_url, :class => 'back-link'
  end

  private

  def incr_counter
    @chart_counter ||= 0
    @chart_counter += 1
  end
end
