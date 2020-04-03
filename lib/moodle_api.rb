class MoodleApi
  def local_api_user_get_logs(uid, lesson_start, lesson_end)
    url = Settings['moodle_api.url']
    url += '?wstoken=' + Settings['moodle_api.token']
    url += '&wsfunction=local_api_user_get_logs'
    url += '&moodlewsrestformat=json'
    url += '&users[0][uid]=' + uid
    url += '&users[0][start]=' + lesson_start.to_s
    url += '&users[0][end]=' + lesson_end.to_s
    result = RestClient.get Addressable::URI.encode(url)
    return JSON.parse(result.body)
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
