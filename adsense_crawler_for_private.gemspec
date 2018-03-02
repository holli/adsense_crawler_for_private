$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "adsense_crawler_for_private/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "adsense_crawler_for_private"
  s.version     = AdsenseCrawlerForPrivate::VERSION
  s.authors     = ["Olli Huotari"]
  s.email       = ["olli.huotari@iki.fi"]
  s.homepage    = "https://github.com/holli/adsense_crawler_for_private/"
  s.summary     = "Easy way to enable adsense crawler to login and see private or custom pages. Basically one custom login filter."
  s.description = "Easy way to enable AdSense crawler to login and see private or custom pages in your rails application. Basically one custom login filter. Gem enables you to easily slightly increase revenues from Google AdSense/AdWords. It makes it easy to enable crawling on private pages and so get better targeted ads even in pages behind login screen."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 5.0"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "mocha", '~> 0.9'


  #s.require_paths = ["lib", "app/controllers/adsense_crawler_for_private"]

end
