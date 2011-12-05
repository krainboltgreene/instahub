require 'bundler/setup'
Bundler.require


get '/' do
  slim :index
end

get '/hub/:user/:repo?' do |user, repo|
  github = "https://github.com/"
  travis = "http://travis-ci.org/"
  slug = File.join(user, repo)
  page = Nokogiri::HTML(Curl::Easy.perform(github + slug).body_str)
  @travis_api = JSON.parse(Curl::Easy.perform(travis + slug + '.json').body_str)
  @status = @travis_api["last_build_status"]
	p @travis_api
  @body = page.css('#readme .wikistyle').inner_html
  slim :readme
end
