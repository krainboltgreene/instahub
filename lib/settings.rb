GITHUB_URL = "https://github.com/"
TRAVIS_URL = "http://travis-ci.org/"

set :views, settings.root + '/presentations'
set :public_folder, settings.root + '/assets'

configure :production do
  Ohm.connect(url: ENV["REDIS_TO_GO_URI"])
end
