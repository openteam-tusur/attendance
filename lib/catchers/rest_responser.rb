module RestResponser
  def self.rest_response(url)
    res = RestClient::Request.execute(
      method: :get,
      url: url,
      timeout: 600.seconds
    ) do |response, request, result, &block|
      response
    end

    {
      code: res.code,
      json: (JSON.load(res.body) rescue [])
    }
  end
end
