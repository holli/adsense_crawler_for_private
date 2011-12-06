#puts "LOADDIING CONTROLLER"

module AdsenseCrawlerForPrivate
  class AdsenseCrawlerLoginController < ApplicationController

    CRAWLER_AD_COOKIE = "joo"
    WES_COOKIE_DOMAIN = "joo" # Set cookie domain automatically with two dots .adsf.inv

    def login
      crawler_name = params[:crawler_name]
      crawler_password = params[:crawler_password]

      #TODO: IP CHECK HERE ALSO
      if (crawler_name == AdsenseCrawlerForPrivate.crawler_name and
          crawler_password == AdsenseCrawlerForPrivate.crawler_password)
        #if (AdsenseCrawlerFilter.crawler_ad_ip_check(request) && crawler_name == CRAWLER_AD_NAME && crawler_password == CRAWLER_AD_PASSWORD)

        cookies.signed[AdsenseCrawlerForPrivate.cookie_name] = {
            :value => AdsenseCrawlerForPrivate.cookie_str(crawler_name, request),
            :expires => 2.days.from_now,
            :domain => :all
        }

        AdsenseCrawlerForPrivate.logger.warn "login successfully. Crawler_name: #{crawler_name}"

        render :text => 'crawler login ok'
      else
        AdsenseCrawlerForPrivate.logger.warn "login unsuccessful. Crawler_name: #{crawler_name}, crawler_password: #{crawler_password}, crawler_ip: #{request.remote_addr}"

        render :text => 'crawler login not ok', :status => 401 # 401 unauthorized
      end

      #AdsenseCrawlerForPrivate.logger.info request.headers.inspect

    end
  
  end
end
