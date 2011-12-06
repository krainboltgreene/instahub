require 'bundler/setup'
Bundler.require

GITHUB_URL = "https://github.com/"
TRAVIS_URL = "http://travis-ci.org/"

get '/' do
  slim :index
end

get '/i/:user/:repo?' do |user, repo|
  github = github_request using_slug_from user, repo
  travis = travis_request using_slug_from user, repo
  readme = readmeify github
  license = licensify github
  travis = apify travis
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

def licensify(page)
  case Nokogiri::HTML(page).css('#readme .wikistyle').inner_html
    when apache2pt0 then "Apache License, Version 2.0"
    when apgl3pt0 then "AGPL-3.0"
    when gpl3pt0 then "GPL-3.0"
    when mit then ""
  end
end

def apify(data)
  JSON.parse data
end

def store(readme)

end

def agpl3pt0
  /"This License" refers to version 3 of the GNU Affero General Public License/mi
end

def apache2pt0
  /Apache License Version 2\.0/mi
end

def gpl3pt0
  /"This License" refers to version 3 of the GNU General Public License/mi
end

def mit
  //mi
end
