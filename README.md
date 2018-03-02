# AdsenseCrawlerForPrivate

Easy way to enable AdSense crawler to login and see private or custom pages in your rails application.
Basically one custom login filter. Gem enables you to easily slightly increase revenues from Google AdSense/AdWords. It
makes it easy to enable crawling on private pages and so get better targeted ads even in pages behind login screen.

[<img src="https://secure.travis-ci.org/holli/adsense_crawler_for_private.png" />](http://travis-ci.org/holli/adsense_crawler_for_private)

## Usage


**Install:** In RAILS_ROOT/Gemfile.rb

```
gem 'adsense_crawler_for_private'
```

**Initialize:** In RAILS_ROOT/config/initializers/adsense_crawler_for_private.rb

```
# Configure adsense_crawler_for_private

AdsenseCrawlerForPrivate.cookie_name = "adsense_crawler"
AdsenseCrawlerForPrivate.cookie_domain = :all
AdsenseCrawlerForPrivate.crawler_name = "test_name"
AdsenseCrawlerForPrivate.crawler_password = "test_password"

# If you are paranoid you can specify ip addresses that are ok to the crawlers to access
# AdsenseCrawlerForPrivate.ip_ranges = [IPAddr.new("127.0.0.1"), IPAddr.new("192.168.0.1/20")]

```

**Routes:**

```
  # Give url "http://domain.dom/adsense_crawler_for_private/login" for crawlers to log in
  # or directly "http://domain.dom/adsense_crawler_for_private/login?name=test_name&password=test_password"
  mount AdsenseCrawlerForPrivate::Engine => "/adsense_crawler_for_private"
```

**Rendering etc usage:** in controller define what to render for crawlers

```

def SomeController << ApplicationController

  before_action :adsense_crawler_private_specific_page # normal authentication filters after this one

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

You can test your filters by setting cookie in the same way as in AdsenseCrawlerLoginController#login .

If you have enabled ip_ranges option you have to make sure that the ip that tests use is enabled for crawlers.

```
test "here would be a test for logged crawler in functional tests"
  # Dummy login for crawler, These should be configured in initializers
  crawler_name="adsense_crawler"; crawler_password = "adsense_pass";
  @request.remote_addr = ip = "127.0.0.1"

  # In some frameworks cookies.signed would be enough. Some will need you to sign the cookie by yourself.
  # If you have a better way, let me know
  # same as cookies.signed[AdsenseCrawlerForPrivate.cookie_name] = AdsenseCrawlerForPrivate.cookie_hash(crawler_name, ip)
  @request.cookies[AdsenseCrawlerForPrivate.cookie_name] =
        ActiveSupport::MessageVerifier.new(Dummy::Application.config.secret_token).generate(
            AdsenseCrawlerForPrivate.cookie_str(crawler_name, crawler_password, 2.days.from_now, ip))


  #Normal test in here
  get :index
  assert_response :success
  assert response.body.include?("Hi normal crawler")
end

test "here would be a test for non-logged crawler"
  get :index
  assert_response :success
  assert response.body.include?("Hi normal user")
end
```

### robots.txt

Remember to update robots.txt if you have previously forbidden adsense to crawl certain pages.

## Requirements

See https://github.com/holli/adsense_crawler_for_private/blob/master/.travis.yml for more info about tests coverage. We try to test with few of the newest Ruby & Rails combination.

[<img src="https://secure.travis-ci.org/holli/adsense_crawler_for_private.png" />](http://travis-ci.org/holli/adsense_crawler_for_private)

http://travis-ci.org/#!/holli/adsense_crawler_for_private

## Support

Submit suggestions or feature requests as a GitHub Issue or Pull Request. Remember to update tests. Tests are quite extensive.

## License

Released under the MIT license (http://www.opensource.org/licenses/mit-license.php)
