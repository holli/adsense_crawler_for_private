AdsenseCrawlerForPrivate::Engine.routes.draw do
  get "login", :controller => "adsense_crawler_login"
  post "login", :controller => "adsense_crawler_login"
end
