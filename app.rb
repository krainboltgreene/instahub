require 'bundler/setup'
Bundler.require

configure do
  set :markdown, options: {fenced_code_blocks: true}
end

get '/' do
  slim :index
end

get '/hub/:user/:repo?' do |user, repo|
  raw = "https://raw.github.com/"
  url = raw + File.join(user, repo, "master", "README.markdown")
  @body = Curl::Easy.perform(url).body_str
  slim :readme
end
