require 'ipaddr'
require "adsense_crawler_for_private/engine"

module AdsenseCrawlerForPrivate

  mattr_accessor :cookie_name, :cookie_domain, :crawler_name, :crawler_password, :ip_ranges

  protected :crawler_password

  # Checks crawler cookie, returns true if logged in
	def self.login_check(cookies, request)
    cookie = cookies.signed[AdsenseCrawlerForPrivate.cookie_name]

    login_ok = false

    if !cookie.blank?
      self.logger.info "login_check: cookie found #{cookie}"
      begin
        name, password, expiry_time, remote_ip = JSON.parse(cookie)
        expiry_time = Time.parse(expiry_time)

        if (name == AdsenseCrawlerForPrivate.crawler_name and
            password == Digest::SHA1.hexdigest(AdsenseCrawlerForPrivate.crawler_password) and
            expiry_time > Time.now and
            self.ip_check(request))
          login_ok = true
          self.logger.warn "login_check was ok for #{name}"
        end
      rescue JSON::ParserError => e
        self.logger.warn "login_check problem parsing cookie json: #{e.inspect}"
      ensure
        unless login_ok
          info_str = "login_check wasn't ok, even though cookie was found."
          info_str += "warning: ip was not accepted" unless self.ip_check(request)
          
          self.logger.warn info_str

          cookies.delete(AdsenseCrawlerForPrivate.cookie_name)
        end
      end
    end
    
    return login_ok
  end

  def self.cookie_hash(crawler_name, crawler_password, request_or_ip)
    {:value => AdsenseCrawlerForPrivate.cookie_str(crawler_name, crawler_password, 2.days.from_now, request_or_ip),
     :expires => 2.days.from_now,
     :domain => AdsenseCrawlerForPrivate.cookie_domain}
  end

  def self.cookie_str(crawler_name, crawler_password, expire_time, request_or_ip)
    ip_str = request_or_ip.respond_to?(:remote_ip) ? request_or_ip.remote_ip : request_or_ip.to_s

    return [crawler_name, Digest::SHA1.hexdigest(crawler_password),
            expire_time.httpdate, ip_str].to_json
  end

  def self.ip_check(request)
    unless AdsenseCrawlerForPrivate.ip_ranges.nil?
      ip_check = ::IPAddr.new(request.remote_ip)
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
