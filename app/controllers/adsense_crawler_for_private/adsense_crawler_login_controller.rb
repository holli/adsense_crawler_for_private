module AdsenseCrawlerForPrivate
  class AdsenseCrawlerLoginController < ApplicationController

    # Making sure that verify_authenticity_token is not on, adsense does not have it
    skip_before_filter :verify_authenticity_token, :only => :login

    def login
      unless AdsenseCrawlerForPrivate.crawler_password.blank?

        crawler_name = params[:name]
        crawler_password = params[:password]

        if (AdsenseCrawlerForPrivate.ip_check(request) and
            crawler_name == AdsenseCrawlerForPrivate.crawler_name and
            crawler_password == AdsenseCrawlerForPrivate.crawler_password)

          cookies.signed[AdsenseCrawlerForPrivate.cookie_name] = AdsenseCrawlerForPrivate.cookie_hash(crawler_name, crawler_password, request.remote_addr)

          AdsenseCrawlerForPrivate.logger.warn "login successfully. Crawler_name: #{crawler_name}"

          render :text => 'crawler login ok', :status => 200
        else
          cookies.delete(AdsenseCrawlerForPrivate.cookie_name, :domain => AdsenseCrawlerForPrivate.cookie_domain)

          AdsenseCrawlerForPrivate.logger.warn "login unsuccessful. Crawler_name: #{crawler_name}, crawler_password: #{crawler_password}, crawler_ip: #{request.remote_addr}"

          render :text => 'crawler login unsuccessful', :status => 401 # 401 unauthorized
        end

      else
        str = "AdsenseCrawlerForPrivate not configured, no password given."
        AdsenseCrawlerForPrivate.logger.warn(str)
        render :text => str, :status => 401
      end

    end
  
  end
end
