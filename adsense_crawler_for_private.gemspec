$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "adsense_crawler_for_private/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "adsense_crawler_for_private"
  s.version     = AdsenseCrawlerForPrivate::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AdsenseCrawlerForPrivate."
  s.description = "TODO: Description of AdsenseCrawlerForPrivate."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"

  #s.require_paths = ["lib", "app/controllers/adsense_crawler_for_private"]

end
