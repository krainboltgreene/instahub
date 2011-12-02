require 'bundler/setup'
Bundler.require


get '/' do
  slim :index
end

get '/hub/:user/:repo?' do |user, repo|
  base = "https://github.com/"
  url = base + File.join(user, repo)
  page = Curl::Easy.perform(url).body_str
  @body = Nokogiri::HTML(page).css('#readme .wikistyle').inner_html
  slim :readme
end
