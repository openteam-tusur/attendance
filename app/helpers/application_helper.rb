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
end
