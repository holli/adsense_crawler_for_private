Rails.application.routes.draw do

  mount AdsenseCrawlerForPrivate::Engine => "/adsense_crawler_for_private"
end
