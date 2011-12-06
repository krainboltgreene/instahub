require 'bundler/setup'
Bundler.require

GITHUB_URL = "https://github.com/"
TRAVIS_URL = "http://travis-ci.org/"

get '/' do
  slim :index
end

get '/i/:user/:repo?' do |user, repo|
  readme = readmeify github_request using_slug_from user, repo
  travis = apify travis_request using_slug_from user, repo
  slim :readme, locals: { readme: readme, travis: travis }
end

def using_slug_from(user, repository)
  user + '/' + repository
end

def github_request(slug)
  Curl::Easy.perform(GITHUB_URL + slug).body_str
end

def travis_request(slug)
  Curl::Easy.perform(TRAVIS_URL + slug + '.json').body_str
end

def readmeify(page)
  Nokogiri::HTML(page).css('#readme .wikistyle').inner_html
end 

def apify(data)
  JSON.parse data
end

def store(readme)

end
