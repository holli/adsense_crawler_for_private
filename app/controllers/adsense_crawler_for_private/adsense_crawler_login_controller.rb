module AdsenseCrawlerForPrivate
  class AdsenseCrawlerLoginController < ApplicationController

    def login
      unless AdsenseCrawlerForPrivate.crawler_password.blank?

        crawler_name = params[:crawler_name]
        crawler_password = params[:crawler_password]

        if (AdsenseCrawlerForPrivate.ip_check(request) and
            crawler_name == AdsenseCrawlerForPrivate.crawler_name and
            crawler_password == AdsenseCrawlerForPrivate.crawler_password)

          cookies.signed[AdsenseCrawlerForPrivate.cookie_name] = AdsenseCrawlerForPrivate.cookie_hash(crawler_name, request.remote_addr)

          AdsenseCrawlerForPrivate.logger.warn "login successfully. Crawler_name: #{crawler_name}"

          render :text => 'crawler login ok'
        else
          cookies.delete(AdsenseCrawlerForPrivate.cookie_name, :domain => AdsenseCrawlerForPrivate.cookie_domain)

          AdsenseCrawlerForPrivate.logger.warn "login unsuccessful. Crawler_name: #{crawler_name}, crawler_password: #{crawler_password}, crawler_ip: #{request.remote_addr}"

          render :text => 'crawler login unsuccessful', :status => 401 # 401 unauthorized
        end

      else
        str = "AdsenseCrawlerForPrivate not configured, no password given."
        AdsenseCrawlerForPrivate.logger(str)
        render :text => str
      end

    end
  
  end
end
