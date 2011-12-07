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
  response = Curl::Easy.perform(GITHUB_URL + slug).body_str
  if response.include? "404" then response = '<div id="readme"><div class="wikistyle"><p>Repository Not Found</p></div></div>' else response end
end

def travis_request(slug)
  response = Curl::Easy.perform(TRAVIS_URL + slug + '.json').body_str
  if response.include? "404" then response = "{}" else response end
end

def readmeify(page)
  Nokogiri::HTML(page).css('#readme .wikistyle').inner_html
end

def licensify(readme)
  case readme
    when /#{apache.join('|')}/mi then { name: 'Apache', link: 'http://www.opensource.org/licenses/Apache-2.0' } 
    when /#{agpl.join('|')}/mi then { name: 'AGPL', link: 'http://www.opensource.org/licenses/AGPL-3.0' } 
    when /#{gpl.join('|')}/mi then { name: 'GPL', link: 'http://www.opensource.org/licenses/GPL-3.0' } 
    when /#{mit.join('|')}/mi then { name: 'MIT', link: 'http://www.opensource.org/licenses/MIT' } 
    when /#{bsd.join('|')}/mi then { name: 'BSD', link: 'http://www.opensource.org/licenses/BSD-3-Clause' } 
  end
end

def apify(data)
  JSON.parse data
end

def store(readme)

end

def agpl
  [
    "GNU Affero General Public License"
  ]
end

def gpl
  [
    "GNU General Public License"
  ]
end

def apache
  [
    "Apache License"
  ]
end

def bsd
  [
    "Redistribution and use in source and binary forms",
    "BSD License"
  ]
end

def mit
  [
    "Permission is hereby granted, free of charge",
    "MIT License"
  ]
end

