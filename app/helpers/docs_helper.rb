module DocsHelper
 def render_erb_template(html)
   doc = Nokogiri::HTML::DocumentFragment.parse(html)
   grouped_permissions = Permission.where(role: "dean").group_by(&:context)
   template = File.open("#{Rails.root}/app/views/documentation/faculties_contacts.html.erb").read
   doc.search('div.faculties-contacts').each do |table|
     table.inner_html = raw ERB.new(template).result(binding)
   end
   doc.to_html.html_safe
 end
end
