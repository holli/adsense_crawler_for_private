# TOOD / KESKEN
# TOOD / KESKEN
# TOOD / KESKEN
# TOOD / KESKEN
# TOOD / KESKEN

0. renamea jos tarvii

Ehdotukset

- adsense_crawler_for_private (taitaa olla selkein että mihin käytetään)
- pages_for_logged_crawler
- logged_crawler <= Tämä varmaan yleiskäyttöisin, sitten descriptioniin että käytetään adsenselle lähinnä
- simple_logger_for_crawlers

Lopulta tämä gemi on vain yksinkertainen tapa logata joku sisään ja käyttää filtereitä handlaamiseen.
Eli parempi nimetä adsensen mukaan, simple_logger ei oikein kertoisi mitään?


1. lisää johonkin, niin että voi käyttää enginen helpereitä controllerissa

class ApplicationController < ActionController::Base
  helper MyEngine::SharedEngineHelper
end


2. lisää login_check

AdsenseCrawlerForPrivate.login_check(request)

3. tee dummy appliin sivut jotka testaa noita

rails g controller crawler_test specific_page_for_crawler, normal_render --skip-assets --skip-helper

ja sitten ohjeiden mukaan alapuolelta

before_filter crawler_private_specific_page, :only => specific_page_for_crawler

def specific_page_for_crawler
  render text => "This would be rendered for non crawler"
end


----------------------------------------------
----------------------------------------------
----------------------------------------------

# AdsenseCrawlerForPrivate

## Usage


in config/initializers

```
set name and password


# If you are paranoid you can specify ip addresses that are ok to access
asdf = [IPAddr.new("127.0.0.1")]

```

in controller define what to render for crawlers


```

def SomeController << ApplicationController

  before_filter :crawler_private_specific_page # normal authentication filters after this one


  def crawler_private_specific_page
    if AdsenseCrawlerForPrivate.login_check(request)
      # here info how to render page for crawler
      # e.g render 'crawler_ad_page'
      # or creating a dummy login info
      return false # so that normal authentication filters etc are not effective
    end
  end

end

```

Or if you want only to check alongside other authentication you can call in your
own authentication filters AdsenseCrawlerForPrivate.login_check(request)-method
directly.



## robots.txt



This project rocks and uses MIT-LICENSE.