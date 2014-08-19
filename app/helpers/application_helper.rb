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
          %w(all from_semester_begin last_week).each do |item|
            f << link_to(I18n.t("filter_labels.#{item}"), params.merge(:filter => item), :class => "btn #{item} #{param == item ? 'active' : 'stub'}")
          end

          f << link_to(I18n.t("filter_labels.date_range"), '#', :class => "btn js-date-range rounded #{param.is_a?(Hash) ? 'active' : 'stub'}", :remote => true)

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
end
