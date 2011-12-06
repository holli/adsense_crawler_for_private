# https://github.com/holli/wes/wiki/Rails-3.1-update

# This could be reformatted to gem/engine
# setup would be by calling AdsenseCrawlerFilter.config = {:asdf => "asdf"}

# and make one extra method to application_controller
# before_filter_adsense_crawler, :only ... , :render_page => 'asdfasdf'

class AdsenseCrawlerFilter

  # Checks crawler cookie, returns true if logged in
	def self.crawler_ad_check(request)
    cookie = request.cookies[CRAWLER_AD_COOKIE]
		crawler_name, expiry_time_s, remote_addr_ip, hash = nil
		cookie_str = nil
		if cookie.is_a?(CGI::Cookie)
			logger.info "crawler_ad_check has a cookie: #{cookie.inspect}"
			if cookie.value.size==4
				logger.info "crawler_ad_check has a cookie array size 4"
				crawler_name, expiry_time_s, remote_addr_ip, hash = cookie.value
			else
				logger.info "crawler_ad_check has a cookie with one value"
				cookie_str = cookie.value.first
			end
		else
			logger.info "crawler_ad_check has a string"
			cookie_str = cookie
    end

		if !cookie_str.nil?  #if hash.blank?
      cookie_str = CGI.unescape(cookie_str)
			crawler_name, expiry_time_s, remote_addr_ip, hash = cookie_str.split('-:-',4)
			if hash.blank? # if it was not unescaped for some reason?
				logger.info "crawler_ad_check string was not unescaped for some reason"
				crawler_name, expiry_time_s, remote_addr_ip, hash = CGI::unescape(cookie_str).split('-:-',4)
			end
		end

		expiry_time = Time.httpdate(expiry_time_s)

		if (AdsenseCrawlerFilter.crawler_ad_ip_check(request) && hash == crawler_ad_hash(crawler_name, expiry_time) && expiry_time > Time.now)
			logger.info "crawler ad cookie expiry & hash ok: name: #{crawler_name}, expiry_time: #{expiry_time}"
			return true
		else
			logger.info "crawler ad cookie not ok: name: #{crawler_name}, expiry_time: #{expiry_time}"
			return false
		end
	end

	#def self.crawler_ad_cookie(name, expiry_time)
	def self.crawler_ad_cookie(name, expiry_time, request)
		return "#{name}-:-#{expiry_time.httpdate}-:-#{request.remote_addr}-:-#{crawler_ad_hash(name, expiry_time)}"
	end

	def self.crawler_ad_hash(name, expiry_time)
#		return Digest::SHA1.hexdigest("#{name}:#{expiry_time.httpdate}:#{request.remote_addr}:#{CRAWLER_AD_PASSWORD}")
		return Digest::SHA1.hexdigest("#{name}:#{expiry_time.httpdate}:#{CRAWLER_AD_PASSWORD}:#{CRAWLER_AD_SALT}")
	end

	def self.crawler_ad_ip_check(request)
		ip_check = IPAddr.new(request.remote_addr)
		ip_ok = false;
		CRAWLER_AD_IP_RANGE.each do |ip_accepted|
			ip_ok = true if ip_accepted.include?(ip_check)
		end
		ip_ok
  end

  protected

  def self.logger
    Rails.logger
  end
end