require 'bundler/setup'
Bundler.require

get '/' do
  slim :index
end

get '/styles/main.css' do
  sass :main
end
