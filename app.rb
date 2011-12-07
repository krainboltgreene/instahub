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
  license = licensify readme
  build = apify travis
  slim :readme, locals: { readme: readme, build: build, license: license }
end

def using_slug_from(user, repository)
  user + '/' + repository
end

def github_request(slug)
  Curl::Easy.perform(GITHUB_URL + slug).body_str
end

def travis_request(slug)
  response = Curl::Easy.perform(TRAVIS_URL + slug + '.json').body_str
  if response.include? "404"
    response = "{}"
  end
  response
end

def readmeify(page)
  Nokogiri::HTML(page).css('#readme .wikistyle').inner_html
end

def licensify(readme)
  case readme
    when false then "Apache"
    when false then "AGPL"
    when false then "GPL"
    when /#{mit.join('|')}/mi then { name: "MIT" } 
  end
end

def apify(data)
  JSON.parse data
end

def store(readme)

end

# def agpl
#   "GNU Affero General Public License"
# end

# def apache
#   "Apache License"
# end

# def gpl
#   "GNU General Public License"
# end

# def bsd
#   "Redistribution and use in source and binary forms" +
#   ", with or without modification, are permitted provided" +
#   " that the following conditions are met"
# end

def mit
  [
    "Permission is hereby granted, free of charge",
    "MIT License"
  ]
end

