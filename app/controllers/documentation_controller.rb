class DocumentationController < ApplicationController
  def show
    begin
    @docs = JSON.parse(
      RestClient::Request.execute(
        method: :get,
        url: "#{Settings['cms.url']}/nodes/documentation/ru/attendance.json",
        content_type: 'application/json',
        accept: 'application/json',
        timeout: 30)
    )['page']['regions']['content']['content']['body']

    rescue
      @docs = I18n.t('temporary_unavailable')
    end
  end
end
