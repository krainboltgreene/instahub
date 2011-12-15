get '/r/:user/:repo?' do |user, repository|
  slug = make_slug_with user, repository
  github = github_request_with slug
  travis = travis_request_with slug
  readme = readmeify github
  license = licensify readme
  build = apify travis
  slim :"readme/show", layout: :"readme/layout", locals: {
    slug: slug,
    readme: readme,
    build: build,
    license: license
  }
end
