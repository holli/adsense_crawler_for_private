
1. Testejä paremmiksi

- ip-checkit
- invalideilla cookieilla yrittäminen
- cookien expiroituminen

1.5 tee oman apin testiin tarvittavat metodit

2. Käyttöön wesiin

3. readme.md viilaus

4. testit continous integration servun kautta


----------------------------------------------
----------------------------------------------
----------------------------------------------

# AdsenseCrawlerForPrivate

## Usage


**Initialize: ** In RAILS_ROOT/config/initializers/adsense_crawler_for_private.rb

```
# Configure adsense_crawler_for_private

AdsenseCrawlerForPrivate.cookie_name = "adsense_crawler"
AdsenseCrawlerForPrivate.cookie_domain = :all
AdsenseCrawlerForPrivate.crawler_name = "craw_name_TEST"
AdsenseCrawlerForPrivate.crawler_password = "crawler_password_TEST"

# If you are paranoid you can specify ip addresses that are ok to the crawlers to access
# AdsenseCrawlerForPrivate.ip_ranges = [IPAddr.new("127.0.0.1/20"), IPAddr.new("192.168.0.1")]

```

**Rendering etc usage:** in controller define what to render for crawlers

```

def SomeController << ApplicationController

  before_filter :adsense_crawler_private_specific_page # normal authentication filters after this one

  def adsense_crawler_private_specific_page
    if AdsenseCrawlerForPrivate.login_check(cookies, request)
      # here info how to render page for crawler
      # e.g render 'crawler_ad_page'
      # or creating a dummy login info
      return false # so that normal authentication filters etc are not effective
    end
  end

  # Here would be rest of the controller

end

```

Or if you want only to check alongside other authentication you can call in your
own authentication filters AdsenseCrawlerForPrivate.login_check(request)-method
directly.


### Testing your own stuff

You can test your filters by setting cookie in the same way as in
AdsenseCrawlerLoginController#login .

```
test "here would be a test"
  # Dummy login for crawler
  cookies.signed[AdsenseCrawlerForPrivate.cookie_name] = AdsenseCrawlerForPrivate.cookie_hash("crawler name str", "127.0.0.1")

  #Normal test in here
  get :index
```

### robots.txt

Remember to update robots.txt if you have previously forbidden adsense to crawl certain pages.

## Requirements

Gem has been tested with ruby 1.8.7, 1.9.2 and Rails 3.1.

http://travis-ci.org/#!/holli/adsense_crawler_for_private

## Support

Submit suggestions or feature requests as a GitHub Issue or Pull Request. Remember to update tests. Tests are quite extensive.

## License

Released under the MIT license (http://www.opensource.org/licenses/mit-license.php)
