class MoodleApi
  def local_api_user_get_logs
    RestClient.log = 'stdout'
    url = Settings['moodle_api.url']
    url += '?wstoken=' + Settings['moodle_api.token']
    url += '&wsfunction=local_api_user_get_logs'
    url += '&moodlewsrestformat=json'
    url += '&users[0][uid]=79d20833-a23e-4073-abf3-1a9904635171'
    url += '&users[0][start]=1585242000'
    url += '&users[0][end]=1585243000'
    url += '&users[1][uid]=79d20833-a23e-4073-abf3-1a9904635171'
    url += '&users[1][start]=1585212000'
    url += '&users[1][end]=1585243000'
    # raise url.inspect
    result = RestClient.get Addressable::URI.encode(url)
    ap JSON.parse(result.body)
  end

  def local_api_cohort_unenrol
    url = Settings['moodle_api.url']
    url += '?wstoken=' + Settings['moodle_api.token']
    url += '&wsfunction=local_api_cohort_unenrol'
    url += '&moodlewsrestformat=json'
    url += '&request%5B0%5D%5Bidnumber%5D=184'
    url += '&request%5B0%5D%5Bcourseid%5D=13'
    result = RestClient.get url
    ap JSON.parse(result.body)
  end
end
