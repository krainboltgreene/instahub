module APIHelper
  def make_slug_with(user, repository)
    user + '/' + repository
  end

  def github_request_with(slug)
    response = Curl::Easy.perform(GITHUB_URL + slug).body_str
    if response.include? "404" then response = '<div id="readme"><div class="wikistyle"><p>Repository Not Found</p></div></div>' else response end
  end

  def travis_request_with(slug)
    response = Curl::Easy.perform(TRAVIS_URL + slug + '.json').body_str
    if response.include? "404" then response = "{}" else response end
  end

  def apify(data)
    JSON.parse data
  end
end
