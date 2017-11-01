module DocsHelper
 def render_erb_template(html)
   doc = Nokogiri::HTML::DocumentFragment.parse(html)
   render_docs_permission_table_for(:dean, doc)
   render_docs_permission_table_for(:subdepartment, doc)
   doc.to_html.html_safe
 end

 def render_docs_permission_table_for(role, doc)
   role = role.to_s.underscore
   grouped_permissions = Permission.where(role: role).group_by(&:context)
   template = File.open("#{Rails.root}/app/views/documentation/#{role.pluralize}_contacts.html.erb").read
   doc.search("div.#{role.pluralize}-contacts").each do |table|
     table.inner_html = raw ERB.new(template).result(binding)
   end
 end
end
