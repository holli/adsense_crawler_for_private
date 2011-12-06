Rails.application.routes.draw do
  get "normal_render", :controller => "main"
  get "forbidden_render", :controller => "main"

  mount AdsenseCrawlerForPrivate::Engine => "/adsense_crawler_for_private"
end
