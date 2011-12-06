# TOOD / KESKEN
# TOOD / KESKEN
# TOOD / KESKEN
# TOOD / KESKEN
# TOOD / KESKEN


# Testejä paremmiksi

- ip-checkit
- invalideilla cookieilla yrittäminen
- cookien expiroituminen


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

### Testing your own stuff

You can test your filters by setting cookie in the same way as in
AdsenseCrawlerLoginController#login

```
In test:
  cookies.signed[AdsenseCrawlerForPrivate.cookie_name] = {
            :value => AdsenseCrawlerForPrivate.cookie_str(crawler_name, request),
            :expires => 2.days.from_now,
            :domain => :all
        }

  Normal test in here
```

### robots.txt

Remember to update robots.txt if you have previously forbidden adsense to crawl certain pages.

## Suppor etc

kato auto_strip_attributes hakemistosta tarvittavat

## License

This project rocks and uses MIT-LICENSE.