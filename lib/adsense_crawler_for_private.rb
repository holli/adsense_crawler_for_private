require 'ipaddr'
require "adsense_crawler_for_private/engine"

module AdsenseCrawlerForPrivate

  mattr_accessor :cookie_name, :crawler_name, :crawler_password, :ip_ranges

  protected :crawler_password

  # Checks crawler cookie, returns true if logged in
	def self.login_check(cookies, request)
    cookie = cookies.signed[AdsenseCrawlerForPrivate.cookie_name]

    login_ok = false

    if !cookie.blank?
      self.logger.info "login_check: cookie found #{cookie}"
      begin
        name, expiry_time, remote_addr = JSON.parse(cookie)
        expiry_time = Time.parse(expiry_time)

        if (name == AdsenseCrawlerForPrivate.crawler_name and
            expiry_time > Time.now and
            request.remote_addr == remote_addr and
            self.ip_check(request))
          login_ok = true
          self.logger.warn "login_check was ok for #{name}"
        end
      rescue JSON::ParserError => e
        self.logger.warn "login_check problem parsing cookie json: #{e.inspect}"
      ensure
        unless login_ok
          self.logger.warn "login_check wasn't ok, even though cookie was found."
          cookies.delete(AdsenseCrawlerForPrivate.cookie_name)
        end
      end
    end
    
    return login_ok
	end

	def self.cookie_str(name, request)
    return [name, 2.days.from_now.httpdate, request.remote_addr].to_json
		#return "#{name}-:-#{expiry_time.httpdate}-:-#{request.remote_addr}-:-#{crawler_ad_hash(name, expiry_time)}"
	end

	def self.ip_check(request)
    unless AdsenseCrawlerForPrivate.ip_ranges.nil?
      ip_check = ::IPAddr.new(request.remote_addr)
      AdsenseCrawlerForPrivate.ip_ranges.each do |ip_accepted|
        return true if ip_accepted.include?(ip_check)
      end
      return false
    end
    return true
  end

  def self.logger
    Logger
  end

  class Logger
    def self.info(str)
      Rails.logger.info("AdsenseCrawlerForPrivate: #{str}")
    end
    def self.warn(str)
      Rails.logger.warn("AdsenseCrawlerForPrivate: #{str}")
    end
  end
end

#class ApplicationController < ActionController::Base
  #   helper MyEngine::SharedEngineHelper
  # end
#end
